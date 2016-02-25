//
//  APITests.swift
//  hiTour
//
//  Created by Adam Chlupacek on 19/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import XCTest
@testable import hiTour


///
/// A mock up to simulate the incoming data from the network
///
class MOCKSession: URLSessionProtocol {
    
    func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult) -> NSURLSessionDataTask {
        let surl = url.standardizedURL!.absoluteString
        var returnData = ""
        print(surl)
        
        switch (surl){
            case "/points":
                returnData = "[{\"id\":1,\"name\":\"POINT1\"},{\"id\":2,\"name\":\"POINT2\"}]"
            
            case "/data":
                returnData = "[{\"id\":1,\"title\":\"DATA1\", \"description\":\"Description1\",\"url\":\"http://s.hswstatic.com/gif/mri-10.jpg\"},{\"id\":2,\"title\":\"DATA2\", \"description\":\"Description2\",\"url\":\"http://s.hswstatic.com/gif/mri-10.jpg\"}]"
            
            case "/audiences":
                returnData = "[{\"id\":1,\"name\":\"AUDIENCE1\"},{\"id\":2,\"name\":\"AUDIENCE2\"}]"
            
            case "/tours":
                returnData = "[{\"id\":1,\"name\":\"TOUR1\",\"audience_id\": 1}]"
            
            case "/tour_points":
                returnData = "[{\"id\":1,\"tour_id\":1,\"point_id\":1, \"rank\":0}, {\"id\":2,\"tour_id\":1,\"point_id\": 2, \"rank\":1}]"
            
            case "/point_data":
                returnData = "[{\"id\":1,\"datum_id\":1,\"point_id\":1,\"rank\":0}, {\"id\":2,\"datum_id\":2,\"point_id\": 1,\"rank\":1}]"
                
            case "/data_audiences":
                returnData = "[{\"id\":1,\"datum_id\":1,\"audience_id\":1},{\"id\":2,\"datum_id\":2,\"audience_id\":1}]"
            
            default:
                {}()
            
        }
        
        completionHandler(returnData.dataUsingEncoding(NSUTF8StringEncoding) ,nil ,nil)
        return MOCKDataTask()
    }
    
    func finishTasksAndInvalidate() -> Void {
        
    }
    
}

///
/// Mock up for the data task returned by session
///
class MOCKDataTask: NSURLSessionDataTask{
    
    override func resume() {
        
    }
    
}

class APITests: XCTestCase {
    
    var connector: ApiConnector?
    var httpClient: HTTPClient?
    var coreDataStack: CoreDataStack?
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        coreDataStack?.deleteAll()
        httpClient = HTTPClient(session: MOCKSession(), baseUrl: "")
        connector = ApiConnector(HTTPClient: httpClient!, stack: coreDataStack!)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        httpClient?.tearDown()
    }
    
    ///
    /// Tests getting of the points via the api
    ///
    func testGettingPoints() {
        let expectation = expectationWithDescription("Expects to retrieve points 2 points")
        connector?.fetchPoints({ (points) -> Void in
            if points.count != 2 {
                XCTFail("Expected to retrieve 2 points, got: \(points.count)")
            } else{
                expectation.fulfill()
            }
        })
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    ///
    /// Tests getting of the data via the api
    ///
    func testGettingData() {
        let expectation = expectationWithDescription("Expects to retrieve points 2 data")
        connector?.fetchData({ (data) -> Void in
            if data.count != 2 {
                XCTFail("Expected to retrieve 2 data, got: \(data.count)")
            } else{
                expectation.fulfill()
            }
        })
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    ///
    /// Tests getting of the audience via the api
    ///
    func testGettingAudience() {
        let expectation = expectationWithDescription("Expects to retrieve points 2 audiences")
        connector?.fetchAudience({ (audiences) -> Void in
            if audiences.count != 2 {
                XCTFail("Expected to retrieve 2 audience, got: \(audiences.count)")
            } else{
                expectation.fulfill()
            }
        })
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    ///
    /// Tests getting of the tours via the api
    ///
    func testGettingTours() {
        let audience = coreDataStack?.insert(Audience.entityName, callback: { (entity, context) -> Audience in
            let aud = Audience(entity: entity, insertIntoManagedObjectContext: context)
            aud.audienceId = 1
            aud.name = "TA1"
            return aud
        })
        
        let expectation = expectationWithDescription("Expects to retrieve points 1 tour")
        connector?.fetchTours([audience!], chain: { (tours) -> Void in
            if tours.count != 1 {
                XCTFail("Expected to retrieve 1 tour, got: \(tours.count)")
            } else if tours.last?.audience?.name != "TA1" {
                XCTFail("Expected to have an audience with name TA1, got: \(tours.last?.audience?.name)")
            } else{
                
                expectation.fulfill()
            }
        })
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    ///
    /// Tests getting of tour-point relation via the api
    ///
    func testGettingPointTour() {
        let expectation = expectationWithDescription("Expects to retrieve the relation of point-tour")
        connector?.fetchPoints({ (points) -> Void in
            self.connector?.fetchAudience({ (audiences) -> Void in
                self.connector?.fetchTours(audiences, chain: { (tours) -> Void in
                    self.connector?.fetchPointTour(tours, points: points, chain: { (pointTours) -> Void in
                        guard pointTours.count == 2 else {
                            XCTFail("Expected to retrieve 2 tourPoints, got: \(pointTours.count)")
                            return
                        }
                        
                        guard let tourIdx = tours.indexOf({$0.tourId == 1}) else {
                            XCTFail("Could not find the tour that should have the tourPoints assigned")
                            return
                        }
                        
                        let tour  = tours[tourIdx]
                        
                        guard tour.pointTours?.count == 2 else {
                            XCTFail("Expected tour to have 2 point tours")
                            return
                        }
                        
                        tour.pointTours?.forEach({ (element) -> () in
                            guard let pt = element as? PointTour else {
                                XCTFail("In the set of point tours, there is something else than pointTour")
                                return
                            }
                            guard pt.point?.pointId == 1 || pt.point?.pointId == 2 else {
                                XCTFail("TourPoint points to a point that should not be pressent")
                                return
                            }
                        })
                        
                        expectation.fulfill()
  
                    })
                })
            })
        })
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    ///
    /// Tests getting of point-data relation via the api
    ///
    func testGettingPointData() {
        let expectation = expectationWithDescription("Expects to retrieve the relation of point-data")
        connector?.fetchPoints({ (points) -> Void in
            self.connector?.fetchData({ (data) -> Void in
                self.connector?.fetchPointData(data, points: points, chain: { (pointData) -> Void in
                    guard pointData.count == 2 else {
                        XCTFail("Expected to retrieve 2 pointData, got: \(pointData.count)")
                        return
                    }
                    
                    guard let pointIdx = points.indexOf({$0.pointId == 1}) else {
                        XCTFail("Could not find the tour that should have the tourPoints assigned")
                        return
                    }
                    
                    let point = points[pointIdx]
                    
                    guard point.pointData?.count == 2 else {
                        XCTFail("Expected point to have 2 pointData")
                        return
                    }
                    
                    point.pointData?.forEach({ (element) -> () in
                        guard let pd = element as? PointData else {
                            XCTFail("In the set of point data, there is something else than PointData")
                            return
                        }
                        guard pd.data?.dataId == 1 || pd.data?.dataId == 2 else {
                            XCTFail("DataPoint points to a data that should not be pressent, id: \(pd.data?.dataId)")
                            return
                        }
                    })
                    
                    expectation.fulfill()
                })
            })
        })
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    ///
    /// Tests getting of data-audience relation via the api
    ///
    func testGettingDataAudience() {
        let expectation = expectationWithDescription("Expects to retrieve the relation of data-audience")
        self.connector?.fetchData({ (data) -> Void in
            self.connector?.fetchAudience({ (audiences) -> Void in
                self.connector?.fetchDataAudiences(data, audiences: audiences, chain: { () -> Void in
                    
                    guard let audienceIdx = audiences.indexOf({$0.audienceId == 1}) else {
                        XCTFail("Could not find the tour that should have the tourPoints assigned")
                        return
                    }
                    
                    let audience = audiences[audienceIdx]
                    
                    guard audience.data?.count == 2 else {
                        XCTFail("Expected point to have 2 pointData got: \(audience.data?.count)")
                        return
                    }
                    
                    audience.data?.forEach({ (element) -> () in
                        guard let d = element as? Data else {
                            XCTFail("In the set of data, there is something else than Data")
                            return
                        }
                        guard d.dataId == 1 || d.dataId == 2 else {
                            XCTFail("DataPoint points to a data that should not be pressent")
                            return
                        }
                    })
                    
                    expectation.fulfill()
                })
            })
        })
        waitForExpectationsWithTimeout(5, handler: nil)
    }

}


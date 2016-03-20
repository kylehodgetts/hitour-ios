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
    
    private var sessionValid = true;
    
    func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult) -> NSURLSessionDataTask {
        let surl = url.standardizedURL!.absoluteString
        var returnData = ""
        
        switch (surl){
            case "/session1":
                if(sessionValid){
                    returnData = "{\"tour_session\":{\"id\":1,\"tour_id\":1,\"start_date\":\"2016-03-16\",\"duration\":30,\"passphrase\":\"session1\",\"created_at\":\"2016-03-15T16:06:35.315Z\",\"updated_at\":\"2016-03-15T16:06:35.315Z\",\"name\":\"Tour with 1st year students\"},\"tours\":{\"id\":1,\"created_at\":\"2016-03-15T16:06:35.089Z\",\"updated_at\":\"2016-03-16T02:54:11.686Z\",\"name\":\"TOUR1\",\"audience_id\":1,\"quiz_url\":\"quiz/address\",\"points\":[{\"id\":1,\"name\":\"POINT1\",\"created_at\":\"2016-03-15T16:06:34.833Z\",\"updated_at\":\"2016-03-15T16:06:34.833Z\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/PointPhoto/fluroscopy.jpg\",\"description\":\"This is a test description\",\"rank\":1,\"data\":[{\"id\":1,\"title\":\"DATA1\",\"description\":\"This video shows a detailed overview of the fluroscopy machine\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/Fluoroscopy/OCH%27s+New+Fluoroscopy+System.mp4\",\"created_at\":\"2016-03-15T16:06:34.514Z\",\"updated_at\":\"2016-03-16T02:54:40.187Z\",\"rank\":1,\"audiences\":[{\"id\":1},{\"id\":2}]},{\"id\":2,\"title\":\"DATA2\",\"description\":\"A ER45SI edition fluroscopy machine.\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/Fluoroscopy/c-arm_fluoroscopy.jpg\",\"created_at\":\"2016-03-15T16:06:34.567Z\",\"updated_at\":\"2016-03-15T16:06:34.567Z\",\"rank\":2,\"audiences\":[{\"id\":1},{\"id\":2}]}]},{\"id\":2,\"name\":\"POINT2\",\"created_at\":\"2016-03-15T16:06:34.852Z\",\"updated_at\":\"2016-03-15T16:06:34.852Z\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/PointPhoto/angiography.jpg\",\"description\":\"This is a test description\",\"rank\":3,\"data\":[{\"id\":3,\"title\":\"DATA3\",\"description\":\"This is a microscopic look at a arteria. It shows how amazing the human body is. I have also run out of things to write.\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/Angiography/Cerebral_angiography%2C_arteria_vertebralis_sinister_injection.jpg\",\"created_at\":\"2016-03-15T16:06:34.595Z\",\"updated_at\":\"2016-03-15T16:06:34.595Z\",\"rank\":1,\"audiences\":[{\"id\":1},{\"id\":2}]},{\"id\":4,\"title\":\"DATA4\",\"description\":\"A brief overview of what an angiography.\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/Angiography/angiography.txt\",\"created_at\":\"2016-03-15T16:06:34.626Z\",\"updated_at\":\"2016-03-15T16:06:34.626Z\",\"rank\":2,\"audiences\":[{\"id\":1},{\"id\":2}]}]},{\"id\":3,\"name\":\"POINT3\",\"created_at\":\"2016-03-15T16:06:34.863Z\",\"updated_at\":\"2016-03-15T16:06:34.863Z\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/PointPhoto/Intravenous+Urograms.png\",\"description\":\"This is a test description\",\"rank\":2,\"data\":[{\"id\":5,\"title\":\"DATA5\",\"description\":\"A breif video showing what the MDI radiology machines function. Blah blah.\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/IVU/MDI+Radiology+CT+IVP+3D.mp4\",\"created_at\":\"2016-03-15T16:06:34.656Z\",\"updated_at\":\"2016-03-15T16:06:34.656Z\",\"rank\":1,\"audiences\":[{\"id\":1},{\"id\":2}]},{\"id\":6,\"title\":\"DATA6\",\"description\":\"An X-Ray scan of an a persons spine, something to do with IVU.\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/IVU/61b13ed65cd0b6785a701239b805fd.PNG\",\"created_at\":\"2016-03-15T16:06:34.683Z\",\"updated_at\":\"2016-03-15T16:06:34.683Z\",\"rank\":2,\"audiences\":[{\"id\":1},{\"id\":2}]}]},{\"id\":5,\"name\":\"POINT5\",\"created_at\":\"2016-03-15T16:06:34.886Z\",\"updated_at\":\"2016-03-15T16:06:34.886Z\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/PointPhoto/NuclearMed.jpg\",\"description\":\"This is a test description\",\"rank\":4,\"data\":[{\"id\":9,\"title\":\"DATA9\",\"description\":\"An X-Ray scan of a persons head.\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/NuclearMedicine/57339506.jpg\",\"created_at\":\"2016-03-15T16:06:34.765Z\",\"updated_at\":\"2016-03-15T16:06:34.765Z\",\"rank\":1,\"audiences\":[{\"id\":1},{\"id\":2}]},{\"id\":10,\"title\":\"DATA10\",\"description\":\"A brief essay, explaining the importance of nuclear medicine.\",\"url\":\"https://s3-us-west-2.amazonaws.com/hitourbucket/ExampleData/NuclearMedicine/nuclear.txt\",\"created_at\":\"2016-03-15T16:06:34.793Z\",\"updated_at\":\"2016-03-15T16:06:34.793Z\",\"rank\":2,\"audiences\":[{\"id\":1},{\"id\":2}]}]}]}}"
                } else {
                    returnData = "Invalid session key"
                }
            
            default:
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    completionHandler(NSData(), nil, nil)

                }
                return MOCKDataTask()

            
        }
        
        completionHandler(returnData.dataUsingEncoding(NSUTF8StringEncoding), nil, nil)
        return MOCKDataTask()
    }
    
    func finishTasksAndInvalidate() -> Void {
        
    }
    
    func expireAll() -> Void {
        sessionValid = false
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
    var mockSession:MOCKSession?
    var coreDataStack: CoreDataStack?
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        coreDataStack?.deleteAll()
        mockSession = MOCKSession()
        httpClient = HTTPClient(session: mockSession!, baseUrl: "")
        connector = ApiConnector(HTTPClient: httpClient!, stack: coreDataStack!)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        httpClient?.tearDown()
    }
    
    
    ///
    /// Checks whether the tours are fetched properly when supplied with correct session
    ///
    ///
    func testGetTour() {
        let expectation = expectationWithDescription("Expects to get full tour as per the request")
        let session = coreDataStack?.insert(Session.entityName){(a, b) in
            let ses = Session(entity: a,insertIntoManagedObjectContext: b)
            ses.sessionCode = "session1"
            return ses
        } as! Session
        
        connector?.fetchTour(session){
            $0.forEach{tour in
                
                guard let points = tour.pointTours?.array as? [PointTour] else {
                    return
                }
                
                let pointCheck = points.reduce(false){(acc, point) in
                    let wrongName = point.point?.name != "POINT1" && point.point?.name != "POINT2" && point.point?.name != "POINT3" && point.point?.name != "POINT5"
                    return acc || (wrongName && point.point?.pointData?.count != 2)
                }
                
                if (tour.audience?.audienceId != 1 ||
                    tour.pointTours?.count != 4 ||
                    tour.name != "TOUR1" ||
                    pointCheck
                ) {
                    return
                }
                
                expectation.fulfill()
            }
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    ///
    /// Tests removing the tour once the session key is expired
    ///
    func testRemoveTour() {
        let expectation = expectationWithDescription("Expects the tour to be removed")

        let session = coreDataStack?.insert(Session.entityName){(a, b) in
            let ses = Session(entity: a,insertIntoManagedObjectContext: b)
            ses.sessionCode = "session1"
            return ses
            } as! Session
        
        connector?.fetchTour(session){
            $0.forEach{tour in
                self.mockSession?.expireAll()
                self.connector?.fetchTour(tour.sessions?.allObjects.first as! Session){ tour in
                    if(tour == nil && self.coreDataStack?.fetch(name: Tour.entityName)?.count == 0){
                        expectation.fulfill()
                    }
                    
                }
            }
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    
}


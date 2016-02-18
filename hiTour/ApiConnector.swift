//
//  ApiConnector.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData

class ApiConnector{
    
    let baseUrl = "https://hitour.herokuapp.com/api/"
    
    let key: String
    let coreDataStack: CoreDataStack
    
    init(apikey key: String, stack coreDataStack: CoreDataStack){
        self.key = key
        self.coreDataStack = coreDataStack
    }
    
    func updateAll() -> Void {
        coreDataStack.deleteAll()
        coreDataStack.saveMainContext()
        
        fetchPoints { (points) -> Void in
            print("Aloha")
            self.fetchAudience({ (audiences) -> Void in
                self.fetchData({ (data) -> Void in
                    self.fetchTours(audiences, chain: { (tours) -> Void in
                        self.fetchPointTour(tours, points: points)
                        self.fetchPointData(data, points: points)
                        self.fetchDataAudiences(data, audiences: audiences)
                        let a:[Point]? = self.coreDataStack.fetch(name: Point.entityName)
                        a?.forEach({print($0.name)})
                    })
                })
            })
        }
        
        
    }
    
    func fetchTours(audiences: [Audience], chain: (([Tour]) -> Void)? ) -> Void {
        request("tours") { (dicts) -> Void in
            let tours = dicts.flatMap({ dict -> Tour? in
                Tour.jsonReader.read(dict).map({self.coreDataStack.insert(Tour.entityName, callback: $0)})
                .map({ (t) -> Tour in
                    if let audienceId = dict["audience_id"] as? Int, idx = audiences.indexOf({$0.audienceId == audienceId}) {
                        t.audience = audiences[idx]
                    }
                    return t
                })
            })
            if let cb = chain {
                cb(tours)
            }
        }
    }
    
    func fetchPoints(chain: (([Point]) -> Void)? ) -> Void {
        request("points") { (dicts) -> Void in
            let points = dicts.flatMap({ dict -> Point? in
                Point.jsonReader.read(dict).map({self.coreDataStack.insert(Point.entityName, callback: $0)})
            })
            if let cb = chain {
                cb(points)
            }
        }
    }
    
    func fetchData(chain: (([Data]) -> Void)? ) -> Void {
        request("data") { (dicts) -> Void in
            let data = dicts.flatMap({ dict -> Data? in
                Data.jsonReader.read(dict).map({self.coreDataStack.insert(Data.entityName, callback: $0)})
            })
            if let cb = chain {
                cb(data)
            }
        }
    }
    
    
    func fetchAudience(chain: (([Audience]) -> Void)? ) -> Void {
        request("audiences") { (dicts) -> Void in
            let audiences = dicts.flatMap({ dict -> Audience? in
                Audience.jsonReader.read(dict).map({self.coreDataStack.insert(Audience.entityName, callback: $0)})
            })
            if let cb = chain {
                cb(audiences)
            }
        }
    }
    
    func fetchPointTour(tours: [Tour], points: [Point], chain: (([PointTour]) -> Void)? = nil ) -> Void {
        request("tour_points") { (dicts) -> Void in
            let pointTours = dicts.flatMap({ dict -> PointTour? in
                let tourPoint = PointTour.jsonReader.read(dict).map({self.coreDataStack.insert(PointTour.entityName, callback: $0)})
                .map({ (pt) -> PointTour in
                    if let tourId = dict["tour_id"] as? Int, idx = tours.indexOf({$0.tourId == tourId}){
                        pt.tour = tours[idx]
                    }
                    
                    if let pointId = dict["point_id"] as? Int, idx = points.indexOf({$0.pointId == pointId}){
                        pt.point = points[idx]
                    }
                    
                    return pt
                })
                
                return tourPoint
            })
            if let cb = chain {
                cb(pointTours)
            }
        }
    }
    
    func fetchPointData(data: [Data], points: [Point], chain: (([PointData]) -> Void)? = nil ) -> Void {
        request("point_data") { (dicts) -> Void in
            let pointTours = dicts.flatMap({ dict -> PointData? in
                let tourPoint = PointData.jsonReader.read(dict).map({self.coreDataStack.insert(PointData.entityName, callback: $0)})
                    .map({ (pd) -> PointData in
                        if let dataId = dict["datum_id"] as? Int, idx = data.indexOf({$0.dataId == dataId}){
                            pd.data = data[idx]
                        }
                        
                        if let pointId = dict["point_id"] as? Int, idx = points.indexOf({$0.pointId == pointId}){
                            pd.point = points[idx]
                        }
                        
                        return pd
                    })
                
                return tourPoint
            })
            if let cb = chain {
                cb(pointTours)
            }
        }
    }

    func fetchDataAudiences(data: [Data], audiences: [Audience], chain: (() -> Void)? = nil ) -> Void {
        request("data_audiences") { (dicts) -> Void in
            dicts.forEach({ dict in
                if let audienceId = dict["audience_id"] as? Int, adx = audiences.indexOf({$0.audienceId == audienceId}), dataId = dict["datum_id"] as? Int, ddx = data.indexOf({$0.dataId == dataId}){
                    let data = data[ddx]
                    var newAudience = [audiences[adx] as AnyObject]
                    newAudience += data.audience!.allObjects
                    data.audience = NSSet(array: newAudience)
                }
            })
            if let cb = chain {
                cb()
            }
        }
    }
    
    
    private func request(url: String, cb: ([[String: AnyObject]]) -> Void) -> Void {
        let nsURL = NSURL(string: baseUrl + key + "/\(url)")!
        print(nsURL.standardizedURL)
        let request = NSURLRequest(URL: nsURL)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(
            request
            , completionHandler: { (data, response, error) -> Void in
                //TODO: error handling and such
                do {
                    print(error)
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [[String: AnyObject]]
                    guard let ret = json else {
                        return
                    }
                    session.invalidateAndCancel()
                    cb(ret)
                } catch {
                    //TODO: ^^ error handling
                    fatalError("DETH TO all... :D")
                }
        })
        task.resume()
    }
}
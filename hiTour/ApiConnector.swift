//
//  ApiConnector.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData

///
/// App that servers a s connection to the server and handles all calls to the api
///
class ApiConnector{
    
    let client: HTTPClient
    let coreDataStack: CoreDataStack
    
    init(HTTPClient client: HTTPClient, stack coreDataStack: CoreDataStack){
        self.client = client
        self.coreDataStack = coreDataStack
    }
    
    
    ///
    /// Drops all data from the coreData and updates them with new values from the server
    ///
    func updateAll(cb: () -> Void) -> Void {
        coreDataStack.deleteAll()
        coreDataStack.saveMainContext()
        var ptFinished = false
        var pdFinished = false
        var daFinished = false
        
        func doneConcurent() -> Void {
            guard ptFinished && pdFinished && daFinished else {
                return
            }
            cb()
        }
        
        fetchPoints { (points) -> Void in
            self.fetchAudience({ (audiences) -> Void in
                self.fetchData({ (data) -> Void in
                    self.fetchTours(audiences, chain: { (tours) -> Void in
                        self.fetchPointTour(tours, points: points, chain: { _ in
                            ptFinished = true; doneConcurent()
                        })
                        self.fetchPointData(data, points: points, chain: { _ in
                            pdFinished = true; doneConcurent()
                        })
                        self.fetchDataAudiences(data, audiences: audiences, chain: { _ in
                            daFinished = true; doneConcurent()
                        })
                    })
                })
            })
        }
    }
    
    ///
    /// A generic fetch method to fetch data from a given url, and then parse them
    ///
    /// Parameters:
    ///  - url: The end url to be fetched rom the api
    ///  - jsonReader: The reader for the objects returned from the api
    ///  - chain: An option of function taht is called once the request is finnished
    ///  - afterParse: A curried function that takes takes the json object and then the already parsed object and does actions
    ///     that need to be done in order to keep the validity of the object
    ///
    internal func fetch<R: JsonReader where R.T: NSManagedObject>(
        url: String
        , jsonReader: R
        , chain: (([R.T]) -> Void)? = nil
        , afterParse: ([String: AnyObject]) -> ((R.T) -> R.T) = {(_) -> ((R.T) -> R.T) in {$0} }
    ) -> Void {
        client.request(url) { (dicts) -> Void in
            let objs = dicts.flatMap({ dict -> R.T? in
                jsonReader.read(dict)
                .map({self.coreDataStack.insert(jsonReader.entityName(), callback: $0)})
                .map(afterParse(dict))
            })
            if let cb = chain {
                cb(objs)
            }
        }
    }
    
    ///
    /// Fetches tours from the server
    ///
    func fetchTours(audiences: [Audience], chain: (([Tour]) -> Void)? ) -> Void {
        fetch("tours", jsonReader: Tour.jsonReader, chain: chain, afterParse: {dict in
            return { (t) -> Tour in
                if let audienceId = dict["audience_id"] as? Int, idx = audiences.indexOf({$0.audienceId == audienceId}) {
                    t.audience = audiences[idx]
                }
                return t
            }
        })
    }
    
    ///
    /// Fetches the points from the server
    ///
    func fetchPoints(chain: (([Point]) -> Void)? ) -> Void {
        fetch("points", jsonReader: Point.jsonReader, chain: chain)
    }
    
    
    ///
    /// Fetches the data from the server
    ///
    func fetchData(chain: (([Data]) -> Void)? ) -> Void {
        fetch("data", jsonReader: Data.jsonReader, chain: chain)
    }
    
    
    ///
    /// Fetches the audiences from the server
    ///
    func fetchAudience(chain: (([Audience]) -> Void)? ) -> Void {
        fetch("audiences", jsonReader: Audience.jsonReader, chain: chain)
    }
    
    ///
    /// Fetches the point - tour relationsships from the srever
    ///
    func fetchPointTour(tours: [Tour], points: [Point], chain: (([PointTour]) -> Void)? = nil ) -> Void {
        fetch("tour_points", jsonReader: PointTour.jsonReader, chain: chain, afterParse: {dict in
            return { (pt) -> PointTour in
                if let tourId = dict["tour_id"] as? Int, idx = tours.indexOf({$0.tourId == tourId}){
                    pt.tour = tours[idx]
                }
                
                if let pointId = dict["point_id"] as? Int, idx = points.indexOf({$0.pointId == pointId}){
                    pt.point = points[idx]
                }
                
                return pt
            }
        })
    }
    
    ///
    /// Fetches teh point - data relationships from the server
    ///
    func fetchPointData(data: [Data], points: [Point], chain: (([PointData]) -> Void)? = nil ) -> Void {
        fetch("point_data", jsonReader: PointData.jsonReader, chain: chain, afterParse: {dict in
            return { (pd) -> PointData in
                if let dataId = dict["datum_id"] as? Int, idx = data.indexOf({$0.dataId == dataId}){
                    pd.data = data[idx]
                }
                
                if let pointId = dict["point_id"] as? Int, idx = points.indexOf({$0.pointId == pointId}){
                    pd.point = points[idx]
                }
                
                return pd
            }
        })
    }

    
    ///
    /// Fetches teh data - audience relationships from the server
    ///
    func fetchDataAudiences(data: [Data], audiences: [Audience], chain: (() -> Void)? = nil ) -> Void {
        client.request("data_audiences") { (dicts) -> Void in
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
    
    

}
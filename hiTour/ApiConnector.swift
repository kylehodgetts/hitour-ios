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
    func updateAll(chain: (() -> Void)? = nil) -> Void {
        coreDataStack.deleteAll()
        coreDataStack.saveMainContext()
        fetchAllCauseWeDumb()
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
                jsonReader.read(dict, stack: self.coreDataStack)
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

    func fetchAllCauseWeDumb(chain: (() -> Void)? = nil) -> Void {

        client.requestObject("Unguessable983") { (dict:[String: AnyObject] ) -> Void in
            guard let tour = dict["tours"] as? [String: AnyObject] else {
                //TODO allert in case something wrong...
                return
            }
            
            guard let points = tour["points"] as? [[String: AnyObject]] else {
                //TODO alert in case points do not exist or smthing
                return
            }
            
            var audiencesS = Set<Audience>()
            
            guard let nsTour = Tour.jsonReader.read(tour, stack: self.coreDataStack).map({self.coreDataStack.insert(Tour.entityName, callback: $0)}) else {
                return
            }
            

            _ = points.flatMap({pDict -> [Point] in
                guard let data = pDict["data"] as? [[String: AnyObject]] else {
                    return []
                }
                
                guard let nsPoint = Point.jsonReader.read(pDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Point.entityName, callback: $0)}) else {
                    return []
                }
                
                if let tourPoint = PointTour.jsonReader.read(pDict, stack: self.coreDataStack).map({self.coreDataStack.insert(PointTour.entityName, callback: $0)}) {
                    tourPoint.tour = nsTour
                    tourPoint.point = nsPoint
                }

                
               _ = data.flatMap({dDict -> [Data] in
                    guard let audiences = dDict["audiences"] as? [[String: AnyObject]] else {
                        return []
                    }
                    
                    let dataAudience = audiences.flatMap({aDict -> [Audience] in
                        if let audience = Audience.jsonReader.read(aDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Audience.entityName, callback: $0)}) {
                            audiencesS.insert(audience)
                            return [audience]
                        }
                        return []
                    })
                
                    if let nsData = Data.jsonReader.read(dDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Data.entityName, callback: $0)}) {
                        let nAudience = (dataAudience as [AnyObject]) + nsData.audience!.allObjects
                        nsData.audience = NSSet(array: nAudience)
                        
                        if let dataPoint = PointData.jsonReader.read(dDict, stack: self.coreDataStack).map({self.coreDataStack.insert(PointData.entityName, callback: $0)}) {
                            dataPoint.point = nsPoint
                            dataPoint.data = nsData
                        }
                        
                        return [nsData]
                    }
                    return []
                
                
                })
                
                return [nsPoint]
                
            })
            
            if let audienceId = tour["audience_id"] as? Int {
                nsTour.audience = audiencesS.filter({$0.audienceId! == audienceId}).last
            }
            
            
            print("Audiences")
            print(self.coreDataStack.fetch(name: Audience.entityName))
            print("Tour")
            print(self.coreDataStack.fetch(name: Tour.entityName))
            print("Data")
            print(self.coreDataStack.fetch(name: Data.entityName))
            print("Point")
            print(self.coreDataStack.fetch(name: Point.entityName))


        }
    }
}
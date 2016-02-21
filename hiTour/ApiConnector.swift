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
    
    let client: HTTPClient
    let coreDataStack: CoreDataStack
    
    init(HTTPClient client: HTTPClient, stack coreDataStack: CoreDataStack){
        self.client = client
        self.coreDataStack = coreDataStack
    }
    
    func updateAll() -> Void {
        coreDataStack.deleteAll()
        coreDataStack.saveMainContext()
        
        fetchPoints { (points) -> Void in
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
    
    func fetchPoints(chain: (([Point]) -> Void)? ) -> Void {
        fetch("points", jsonReader: Point.jsonReader, chain: chain)
    }
    
    func fetchData(chain: (([Data]) -> Void)? ) -> Void {
        fetch("data", jsonReader: Data.jsonReader, chain: chain)
    }
    
    
    func fetchAudience(chain: (([Audience]) -> Void)? ) -> Void {
        fetch("audiences", jsonReader: Audience.jsonReader, chain: chain)
    }
    
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
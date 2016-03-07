//
//  Point.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData


class Point: NSManagedObject {
    
    static let entityName = "Point"
    static let jsonReader = PointReader()
    
    
    func getPointDataFor(audience: Audience) -> [PointData] {
        let filtered =
            self.pointData!.filter { (object) -> Bool in
                guard let pointData = object as? PointData else {
                    return false
                }
                return pointData.data!.audience!.containsObject(audience)
            }
        return filtered.map({$0 as! PointData})
    }

}


class PointReader: JsonReader{
    typealias T = Point

    func read(dict: [String: AnyObject], stack: CoreDataStack) -> ((NSEntityDescription, NSManagedObjectContext) -> Point)? {
        guard let id = dict["id"] as? Int, name = dict["name"] as? String else {
            return nil
        }
        
        let fetch = stack.fetch(name: entityName(), predicate: NSPredicate(format: "pointId = %D", id))
        
        if let actual = fetch?.last as? Point {
            return {_, _ in actual}
            
        } else {
            return
                {(entity: NSEntityDescription, context: NSManagedObjectContext) -> Point in
                    let point = Point(entity: entity, insertIntoManagedObjectContext: context)
                    point.pointId = id
                    point.name = name

                    
                    return point
            }
        }
    }
    
    func entityName() -> String {
        return Point.entityName
    }
}
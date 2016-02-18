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


// Insert code here to add functionality to your managed object subclass

}


class PointReader: JsonReader{
    typealias T = Point
    
    func read(dict: [String: AnyObject]) -> ((NSEntityDescription, NSManagedObjectContext) -> Point)? {
        guard let id = dict["id"] as? Int, name = dict["name"] as? String else {
            return nil
        }
        
        return
            {(entity: NSEntityDescription, context: NSManagedObjectContext) -> Point in
                let point = Point(entity: entity, insertIntoManagedObjectContext: context)
                point.pointId = id
                point.name = name
                
                return point
        }
    }
}
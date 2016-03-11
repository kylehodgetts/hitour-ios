//
//  PointData.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData


class PointData: NSManagedObject {
    
    static let entityName = "PointData"
    static let jsonReader = PointDataReader()

}

class PointDataReader: JsonReader{
    typealias T = PointData
    
    func read(dict: [String: AnyObject], stack: CoreDataStack) -> ((NSEntityDescription, NSManagedObjectContext) -> PointData)? {
        guard let rank = dict["rank"] as? Int else {
            return nil
        }
        
        return
            {(entity: NSEntityDescription, context: NSManagedObjectContext) -> PointData in
                let point = PointData(entity: entity, insertIntoManagedObjectContext: context)
                point.rank = rank
                
                return point
        }
    }
    
    func entityName() -> String {
        return PointData.entityName
    }
}
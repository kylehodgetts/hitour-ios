//
//  PointTour.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData


class PointTour: NSManagedObject {
    
    static let entityName = "PointTour"
    static let jsonReader = PointTourReader()



// Insert code here to add functionality to your managed object subclass

}

class PointTourReader: JsonReader{
    typealias T = PointTour
    
    func read(dict: [String: AnyObject]) -> ((NSEntityDescription, NSManagedObjectContext) -> PointTour)? {
        guard let rank = dict["rank"] as? String else {
            return nil
        }
        
        return
            {(entity: NSEntityDescription, context: NSManagedObjectContext) -> PointTour in
                let pointTour = PointTour(entity: entity, insertIntoManagedObjectContext: context)
                pointTour.rank = rank
                
                return pointTour
        }
    }
}
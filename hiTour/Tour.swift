//
//  Tour.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData


class Tour: NSManagedObject {
    
    static let entityName = "Tour"
    static let jsonReader = TourReader()

}

class TourReader: JsonReader{
    typealias T = Tour
    
    func read(dict: [String: AnyObject], stack: CoreDataStack) -> ((NSEntityDescription, NSManagedObjectContext) -> Tour)? {
        guard let id = dict["id"] as? Int, name = dict["name"] as? String else {
            return nil
        }
        
        let fetch = stack.fetch(name: entityName(), predicate: NSPredicate(format: "tourId = %D", id))
        
        if let actual = fetch?.last as? Tour {
            return {_, _ in actual}
            
        } else {
            return
                {(entity: NSEntityDescription, context: NSManagedObjectContext) -> Tour in
                    let tour = Tour(entity: entity, insertIntoManagedObjectContext: context)
                    tour.tourId = id
                    tour.name = name
                    
                    return tour
            }
        }
    }
    
    func entityName() -> String {
      return Tour.entityName
    }
}
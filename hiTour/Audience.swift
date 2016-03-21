//
//  Audience.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData


class Audience: NSManagedObject {
    
    static let entityName = "Audience"
    static let jsonReader = AudienceReader()

}


class AudienceReader: JsonReader{
    typealias T = Audience
    
    ///
    /// Parses the object and stores it in the core data
    ///
    func read(dict: [String: AnyObject], stack: CoreDataStack) -> ((NSEntityDescription, NSManagedObjectContext) -> Audience)? {
        guard let id = dict["id"] as? Int else {
            return nil
        }
        
        let fetch = stack.fetch(name: entityName(), predicate: NSPredicate(format: "audienceId = %D", id))
        
        if let actual = fetch?.last as? Audience {
            return {_, _ in actual}
            
        } else {
            return
                {(entity: NSEntityDescription, context: NSManagedObjectContext) -> Audience in
                    let audience = Audience(entity: entity, insertIntoManagedObjectContext: context)
                    audience.audienceId = id
                    return audience
            }
        }
    }
    
    func entityName() -> String {
        return Audience.entityName
    }
}
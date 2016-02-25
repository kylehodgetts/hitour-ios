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
    
    func read(dict: [String: AnyObject]) -> ((NSEntityDescription, NSManagedObjectContext) -> Audience)? {
        guard let id = dict["id"] as? Int, name = dict["name"] as? String else {
            return nil
        }
        
        return
            {(entity: NSEntityDescription, context: NSManagedObjectContext) -> Audience in
                let audience = Audience(entity: entity, insertIntoManagedObjectContext: context)
                audience.audienceId = id
                audience.name = name                
                return audience
        }
    }
    
    func entityName() -> String {
        return Audience.entityName
    }
}
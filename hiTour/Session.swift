//
//  Session.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData


class Session: NSManagedObject {
    
    static let entityName = "Session"
    static let jsonReader = SessionReader()
}

class SessionReader: JsonReader{
    typealias T = Session
    
    func read(dict: [String: AnyObject], stack: CoreDataStack) -> ((NSEntityDescription, NSManagedObjectContext) -> Session)? {
        guard let id = dict["id"] as? Int, name = dict["name"] as? String else {
            return nil
        }
        
        return
            {(entity: NSEntityDescription, context: NSManagedObjectContext) -> Session in
                let point = Session(entity: entity, insertIntoManagedObjectContext: context)
                //TODO: finish the reader, dunno if it will even be user or what is actually going on with sessions etc
                
                return point
        }
    }
    
    func entityName() -> String {
        return Session.entityName
    }
}
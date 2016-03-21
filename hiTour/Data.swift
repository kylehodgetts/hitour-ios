//
//  Data.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData


class Data: NSManagedObject {
    
    static let entityName = "Data"
    static let jsonReader = DataReader()

}

class DataReader: JsonReader{
    typealias T = Data
    
    func read(dict: [String: AnyObject], stack: CoreDataStack) -> ((NSEntityDescription, NSManagedObjectContext) -> Data)? {
        guard let id = dict["id"] as? Int, title = dict["title"] as? String, description = dict["description"] as? String, url = dict["url"] as? String else {
            return nil
        }
        
        
        let fetch = stack.fetch(name: entityName(), predicate: NSPredicate(format: "dataId = %D", id))
        
        if let actual = fetch?.last as? Data {
            return {_, _ in
                actual.title = title
                actual.descriptionD = description
                actual.url = url
                return actual
            }
            
        } else {
            return
                {(entity: NSEntityDescription, context: NSManagedObjectContext) -> Data in
                    let data = Data(entity: entity, insertIntoManagedObjectContext: context)
                    data.dataId = id
                    data.title = title
                    data.descriptionD = description
                    data.url = url
                    data.audience = NSSet()
                    
                    return data
            }
        }
    }
    
    func entityName() -> String {
        return Data.entityName
    }
}
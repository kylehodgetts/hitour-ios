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


// Insert code here to add functionality to your managed object subclass

}

class DataReader: JsonReader{
    typealias T = Data
    
    func read(dict: [String: AnyObject]) -> ((NSEntityDescription, NSManagedObjectContext) -> Data)? {
        guard let id = dict["id"] as? Int, title = dict["title"] as? String, description = dict["description"] as? String, url = dict["url"] as? String else {
            return nil
        }
        
        return
            {(entity: NSEntityDescription, context: NSManagedObjectContext) -> Data in
                let data = Data(entity: entity, insertIntoManagedObjectContext: context)
                data.dataId = id
                data.title = title
                data.descriptionD = description
                data.url = url
                
                return data
        }
    }
}
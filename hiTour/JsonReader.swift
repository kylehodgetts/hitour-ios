//
//  JsonReader.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData

///
/// A generic reader of json objects, is meant to be used together with coredata as it expects 
/// to be returning a function that will have an entity for the object as well as context
///
protocol JsonReader{
    typealias T: NSManagedObject
   
    func read(dict: [String: AnyObject]) -> ((NSEntityDescription, NSManagedObjectContext) -> T)?
    
    func entityName() -> String
}
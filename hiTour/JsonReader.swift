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
    
    /// The type of the returned object
    typealias T: NSManagedObject
   
    ///
    /// Reads a json object and returns a function that stores the object into core data
    ///
    /// Parameters: 
    ///  - dict: A json object wrapped in a dictionary
    ///
    func read(dict: [String: AnyObject]) -> ((NSEntityDescription, NSManagedObjectContext) -> T)?
    
    /// The name of the entity this reader is for
    func entityName() -> String
}
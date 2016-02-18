//
//  JsonReader.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData

protocol JsonReader{
    typealias T
   
    func read(dict: [String: AnyObject]) -> ((NSEntityDescription, NSManagedObjectContext) -> T)?
}
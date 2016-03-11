//
//  PointTour+CoreDataProperties.swift
//  hiTour
//
//  Created by Adam Chlupacek on 07/03/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PointTour {

    @NSManaged var rank: NSNumber?
    @NSManaged var scanned: NSNumber?
    @NSManaged var point: Point?
    @NSManaged var tour: Tour?

}

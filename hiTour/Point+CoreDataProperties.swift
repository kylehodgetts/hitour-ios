//
//  Point+CoreDataProperties.swift
//  hiTour
//
//  Created by Adam Chlupacek on 04/03/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Point {

    @NSManaged var name: String?
    @NSManaged var pointId: NSNumber?
    @NSManaged var data: NSData?
    @NSManaged var descriptionP: String?
    @NSManaged var pointData: NSOrderedSet?
    @NSManaged var pointTours: NSSet?

}

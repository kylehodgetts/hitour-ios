//
//  Point+CoreDataProperties.swift
//  hiTour
//
//  Created by Charlie Baker on 06/03/2016.
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
    @NSManaged var discovered: NSNumber?
    @NSManaged var pointData: NSSet?
    @NSManaged var pointTours: NSSet?

}

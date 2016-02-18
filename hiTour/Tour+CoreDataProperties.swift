//
//  Tour+CoreDataProperties.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tour {

    @NSManaged var tourId: String?
    @NSManaged var name: String?
    @NSManaged var pointTours: NSSet?
    @NSManaged var audience: NSSet?
    @NSManaged var sessions: NSSet?

}

//
//  Tour+CoreDataProperties.swift
//  hiTour
//
//  Created by Adam Chlupacek on 15/03/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tour {

    @NSManaged var name: String?
    @NSManaged var tourId: NSNumber?
    @NSManaged var quizUrl: String?
    @NSManaged var audience: Audience?
    @NSManaged var pointTours: NSOrderedSet?
    @NSManaged var sessions: NSSet?

}

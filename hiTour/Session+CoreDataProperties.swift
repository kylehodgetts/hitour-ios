//
//  Session+CoreDataProperties.swift
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

extension Session {

    @NSManaged var sessionId: String?
    @NSManaged var startData: NSDate?
    @NSManaged var endData: NSDate?
    @NSManaged var sessionCode: String?
    @NSManaged var tour: NSManagedObject?

}

//
//  Data+CoreDataProperties.swift
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

extension Data {

    @NSManaged var dataId: NSNumber?
    @NSManaged var descriptionD: String?
    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var audience: NSSet?
    @NSManaged var pointData: NSSet?

}

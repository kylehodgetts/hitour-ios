//
//  PointData+CoreDataProperties.swift
//  hiTour
//
//  Created by Adam Chlupacek on 19/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PointData {

    @NSManaged var rank: NSNumber?
    @NSManaged var data: Data?
    @NSManaged var point: Point?

}

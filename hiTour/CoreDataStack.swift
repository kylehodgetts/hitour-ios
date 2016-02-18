//
//  CoreDataStack¨.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    
    static let moduleName = "hiTour"
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.last!
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(moduleName).sqlite")
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            fatalError("Could not add persistent store \(error)")
        }
        
        return coordinator
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func insert<T: NSManagedObject>(name: String, @noescape callback: (NSEntityDescription, NSManagedObjectContext) -> T ) -> Void {
        guard let description = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext) else {
            fatalError("Creating an entity that does not exist")
        }
        callback(description, managedObjectContext)
    }
    
    func fetch<T: NSManagedObject>(
        name entityName: String
        , predicate: NSPredicate? = nil
        , sort sortDescriptors: [NSSortDescriptor]? = nil
        , errorHandler: (ErrorType) -> Void = {fatalError("There was an error in fetching from coredata \($0)")}
    ) -> [T]? {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
            return try managedObjectContext.executeFetchRequest(request) as? [T]
        } catch {
            errorHandler(error)
        }
        return []

    }
    
    func saveMainContext(errorHandler: (ErrorType) -> Void = {err in fatalError("Error occured while saving\(err)")}) -> Void {
        do {
            try managedObjectContext.save()
        } catch {
            errorHandler(error)
        }
    }
    
}
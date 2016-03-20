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
    
    private lazy var applicationDocumentsDirectory: NSURL = {
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
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options:
                [NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true])
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
    
    
    /**
     * Method name: insert
     * Description: Inserts a given entity into coreData, THE ENTITY IS NOT PERSISTENTLY SAVED!
     * Parameters: 
     *  - entityName:   The name of the entity to be inserted
     *  - callback:     The callback on created entityDescription, passes ManagedObjectContext as well
     *                  this is unsave as such should be treated carefully
     */
    func insert<T: NSManagedObject>(entityName: String, callback: (NSEntityDescription, NSManagedObjectContext) -> T ) -> T {
        guard let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext) else {
            fatalError("Creating an entity that does not exist")
        }
        return callback(description, managedObjectContext)
    }
    
    /**
     * Method name: fetch
     * Description: Fetches resources from the core data
     * Parameters: 
     *  - entityName:       The name of the entity to be fetched
     *  - predicate:        The predicate to be used with this query
     *  - sortDescriptors:  The sort of the fetch query
     *  - errorHandler:     Handles a possible error thhat was emited while fetching the objects
     */
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
    
    /**
     * Method name: saveMainContext
     * Description: Saves the changes to the context to make them persistent
     * Parameters: 
     *  - errorHandler: Handles a possible error that was emited while saving the context
     */
    func saveMainContext(errorHandler: (ErrorType) -> Void = {fatalError("Error occured while saving\($0)")}) -> Void {
        do {
            try managedObjectContext.save()
        } catch {
            errorHandler(error)
        }
    }
    
    func delete(object: NSManagedObject) -> Void {
        managedObjectContext.deleteObject(object);
    }
    
    func deleteAll() -> Void {
        deleteEntity(Tour.entityName)
        deleteEntity(Session.entityName)
        deleteEntity(Data.entityName)
        deleteEntity(Point.entityName)
        deleteEntity(PointData.entityName)
        deleteEntity(PointTour.entityName)
        deleteEntity(Audience.entityName)
    }
    
    func deleteEntity(entity: String){
        fetch(name: entity)?.forEach(self.delete)
    }
    
}
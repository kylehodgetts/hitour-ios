//
//  CoredataTest.swift
//  hiTour
//
//  Created by Adam Chlupacek on 19/03/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import XCTest
@testable import hiTour

class CoreDataTests: XCTestCase {
    
    var coreDataStack: CoreDataStack?
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        coreDataStack?.deleteAll()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    ///
    /// Tests deleting all of the data from the core data
    ///
    func testDeleteAll(){
        coreDataStack?.insert(Tour.entityName){ (a,b) in
            let t = Tour(entity: a, insertIntoManagedObjectContext: b)
            t.name = "Test"
            return t
        }
        coreDataStack?.saveMainContext()
        coreDataStack?.deleteAll()
        XCTAssert(coreDataStack?.fetch(name: Tour.entityName)?.count == 0, "Did not manage to delete all in the coredata")
    }
    
    ///
    /// Tests inserting into core data
    ///
    func testInsert(){
        let session = coreDataStack?.insert(Session.entityName){(entity, context) in
            let session = Session(entity: entity, insertIntoManagedObjectContext: context)
            session.sessionCode = "CODE1"
            return session
        } as! Session
        
        let fetchedSession = coreDataStack?.fetch(name: Session.entityName)?.first as! Session
        
        XCTAssert(session.sessionCode == "CODE1", "Inserted session has CODE1 as its sessioncode")
        XCTAssert(fetchedSession.sessionCode == "CODE1", "Fetched session has CODE1 as its sessioncode")
        XCTAssert(session == fetchedSession, "Inserted and fetched session are the same")
    }

    ///
    /// Tests delete of one item from core data
    ///
    func testDelete(){
        let session = coreDataStack?.insert(Session.entityName){(entity, context) in
            let session = Session(entity: entity, insertIntoManagedObjectContext: context)
            session.sessionCode = "CODE1"
            return session
        } as! Session
        coreDataStack?.delete(session)
        let fetchedSession = coreDataStack?.fetch(name: Session.entityName)?.first
        XCTAssert(fetchedSession.isEmpty(), "The entity fetched has to be empty")
    }
    
    ///
    /// Tests delete of all the data in one entity
    ///
    func testDeleteEntity(){
        let _ = coreDataStack?.insert(Session.entityName){(entity, context) in
            let session = Session(entity: entity, insertIntoManagedObjectContext: context)
            session.sessionCode = "CODE1"
            return session
        }
        coreDataStack?.deleteEntity(Session.entityName)
        let fetchedSession = coreDataStack?.fetch(name: Session.entityName)?.first
        XCTAssert(fetchedSession.isEmpty(), "The entity fetched has to be empty")
    }
    
    ///
    /// Tests fetching of a record from the core data
    ///
    func testFetchOne(){
        let _ = coreDataStack?.insert(Session.entityName){(entity, context) in
            let session = Session(entity: entity, insertIntoManagedObjectContext: context)
            session.sessionCode = "CODE1"
            return session
        }
        let fetchSession = coreDataStack?.fetch(name: Session.entityName)?.first as! Session
        XCTAssert(fetchSession.sessionCode == "CODE1", "Has to fetch two sessions")
    }
    
    ///
    /// Tests fetching of multiple records from the core data
    ///
    func testFetchMultiple(){
        let _ = coreDataStack?.insert(Session.entityName){(entity, context) in
            let session = Session(entity: entity, insertIntoManagedObjectContext: context)
            session.sessionCode = "CODE1"
            return session
        }
        let _ = coreDataStack?.insert(Session.entityName){(entity, context) in
            let session = Session(entity: entity, insertIntoManagedObjectContext: context)
            session.sessionCode = "CODE2"
            return session
        }
        let fetchAllSessions = coreDataStack?.fetch(name: Session.entityName)
        XCTAssert(fetchAllSessions?.count == 2, "Has to fetch two sessions")
    }
    
    ///
    /// Tests fetching of filtered record from the core data
    ///
    func testFetchFilterOne(){
        let _ = coreDataStack?.insert(Session.entityName){(entity, context) in
            let session = Session(entity: entity, insertIntoManagedObjectContext: context)
            session.sessionCode = "CODE1"
            return session
        }
        let _ = coreDataStack?.insert(Session.entityName){(entity, context) in
            let session = Session(entity: entity, insertIntoManagedObjectContext: context)
            session.sessionCode = "CODE2"
            return session
        }
        let fetchAllSessions = coreDataStack?.fetch(name: Session.entityName, predicate: NSPredicate(format: "sessionCode = %@", "CODE2"))
        XCTAssert(fetchAllSessions?.count == 1, "Has to fetch two sessions")
    }
    

}
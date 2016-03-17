//
//  PointDiscoveryTest.swift
//  hiTour
//
//  Created by Charlie Baker on 10/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import XCTest

class PointDiscoveryTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Test to check that when a point is scanned it goes to the correct point Detail View
    func testScannedPointNavigation() {
        
        let app = XCUIApplication()
        
        NSThread.sleepForTimeInterval(4)
        
        app.tabBars.buttons["Scanner"].tap()
        app.sheets["Input Device Error"].collectionViews.buttons["Ok"].tap()
        
        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        
        let shiftButton = app.buttons["shift"]
        shiftButton.tap()
        shiftButton.tap()
        shiftButton.tap()
        shiftButton.tap()
        enterAPassphraseTextField.typeText("SNP")
        shiftButton.tap()
        enterAPassphraseTextField.typeText("enguins")
        
        let moreNumbersKey = app.keys["more, numbers"]
        moreNumbersKey.tap()
        enterAPassphraseTextField.typeText("123")
        app.buttons["Done"].tap()
        
        NSThread.sleepForTimeInterval(4)
        
        
        app.tabBars.buttons["Scanner"].tap()
        app.sheets["Input Device Error"].collectionViews.buttons["Ok"].tap()
        
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        
        shiftButton.tap()
        shiftButton.tap()
        enterAPassphraseTextField.typeText("POINT")
        
        moreNumbersKey.tap()
        enterAPassphraseTextField.typeText("-2")
        app.buttons["Done"].tap()
        
    }
    
    
    func testOnlyUnlockedPointAccessible() {
        
        let app = XCUIApplication()
        
        NSThread.sleepForTimeInterval(4)
        
        app.tabBars.buttons["Scanner"].tap()
        app.sheets["Input Device Error"].collectionViews.buttons["Ok"].tap()
        
        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        
        let shiftButton = app.buttons["shift"]
        shiftButton.tap()
        shiftButton.tap()
        shiftButton.tap()
        shiftButton.tap()
        enterAPassphraseTextField.typeText("SNP")
        shiftButton.tap()
        enterAPassphraseTextField.typeText("enguins")
        
        let moreNumbersKey = app.keys["more, numbers"]
        moreNumbersKey.tap()
        enterAPassphraseTextField.typeText("123")
        app.buttons["Done"].tap()
        
        NSThread.sleepForTimeInterval(4)

        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Angiography"].tap()
        app.navigationBars["hiTour.FeedPageView"].buttons["hiTour"].tap()
        collectionViewsQuery.staticTexts["Nuclear Medicine"].tap()
        collectionViewsQuery.staticTexts["Magnetic Resonance Imaging (MRI)"].tap()
        
    }
    
    /// Test that checks manual input of a point id displays the correct point
    func testManualPointEntryDiscovery() {
        
        let app = XCUIApplication()
        
        NSThread.sleepForTimeInterval(4)
        
        app.tabBars.buttons["Scanner"].tap()
        app.sheets["Input Device Error"].collectionViews.buttons["Ok"].tap()
        
        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        
        let shiftButton = app.buttons["shift"]
        shiftButton.tap()
        shiftButton.tap()
        shiftButton.tap()
        shiftButton.tap()
        enterAPassphraseTextField.typeText("SNP")
        shiftButton.tap()
        enterAPassphraseTextField.typeText("enguins")
        
        let moreNumbersKey = app.keys["more, numbers"]
        moreNumbersKey.tap()
        enterAPassphraseTextField.typeText("123")
        app.buttons["Done"].tap()
        
        NSThread.sleepForTimeInterval(4)

        
        app.tabBars.buttons["Scanner"].tap()
        app.sheets["Input Device Error"].collectionViews.buttons["Ok"].tap()
        
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        let deleteKey = app.keys["delete"]
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        
        shiftButton.tap()
        shiftButton.tap()
        enterAPassphraseTextField.typeText("POINT")
        
        moreNumbersKey.tap()
        enterAPassphraseTextField.typeText("-5")
        
        let app2 = app
        app2.buttons["Done"].tap()
        app2.collectionViews.staticTexts["Nuclear Medicine"].tap()
    }
    
    /// Test that checks points scanned not on the tour are correctly handled by showing the user
    /// an error message that the point is not found
    func testIncorrectPointScannedIsHandled() {
        let app = XCUIApplication()
        
        NSThread.sleepForTimeInterval(4)
        
        app.tabBars.buttons["Scanner"].tap()
        app.sheets["Input Device Error"].collectionViews.buttons["Ok"].tap()
        
        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        
        let shiftButton = app.buttons["shift"]
        shiftButton.tap()
        shiftButton.tap()
        shiftButton.tap()
        shiftButton.tap()
        enterAPassphraseTextField.typeText("SNP")
        shiftButton.tap()
        enterAPassphraseTextField.typeText("enguins")
        
        let moreNumbersKey = app.keys["more, numbers"]
        moreNumbersKey.tap()
        enterAPassphraseTextField.typeText("123")
        app.buttons["Done"].tap()
        
        NSThread.sleepForTimeInterval(4)

        
        app.tabBars.buttons["Scanner"].tap()
        
        let okButton = app.sheets["Input Device Error"].collectionViews.buttons["Ok"]
        okButton.tap()
        
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        let deleteKey = app.keys["delete"]
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        
        shiftButton.tap()
        shiftButton.tap()
        enterAPassphraseTextField.typeText("POINT")
        
        moreNumbersKey.tap()
        enterAPassphraseTextField.typeText("-1")
        app.buttons["Done"].tap()
        app.sheets["Point Not Found"].collectionViews.buttons["OK"].tap()
        
    }
    
}

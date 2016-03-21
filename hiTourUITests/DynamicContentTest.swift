//
//  DynamicContentTest.swift
//  hiTour
//
//  Created by Charlie Baker on 02/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import XCTest

//  Test class to check that dynamic content is being generated and populated into the views correctly
//  This class also tests the functionality of videos and images.
class DynamicContentTest: XCTestCase {
    
    //  Setup function that needs to setup the tests
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    //  Required function to tear everything down after each test
    override func tearDown() {
        super.tearDown()
    }
    
    //  Test that checks the video content is dynamically populated correctly as well as check their controls work
    //  as expected in both normal mode and full screen mode. So that the user is able to control the videos
    func testVideoContent() {
        
        let app = XCUIApplication()
        
        NSThread.sleepForTimeInterval(15)
        
        let tabBarsQuery = app.tabBars
        let scannerButton = tabBarsQuery.buttons["Scanner"]
        scannerButton.tap()
        
        let okButton = app.sheets["Input Device Error"].collectionViews.buttons["Ok"]
        okButton.tap()
        
        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("SNneckwear73")
        app.typeText("\r")
        
        NSThread.sleepForTimeInterval(20)
        
        scannerButton.tap()
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
        
        enterAPassphraseTextField.typeText("POINT-1")
        app.typeText("\r")
        
        NSThread.sleepForTimeInterval(15)
        
        let collectionViewsQuery2 = app.collectionViews
        collectionViewsQuery2.cells.otherElements.containingType(.StaticText, identifier:"Fluroscopy System Video - Modified").childrenMatchingType(.TextView).element.swipeUp()
        
        let collectionViewsQuery = collectionViewsQuery2
        collectionViewsQuery.buttons["PlayButton"].tap()
        collectionViewsQuery.otherElements["Video"].tap()
        collectionViewsQuery.buttons["EnterFullScreenButton"].tap()
        app.buttons["Done"].tap()
        
        XCTAssertNotNil(collectionViewsQuery.buttons["PlayButton"])
        XCTAssertNotNil(collectionViewsQuery.otherElements["Video"])
        XCTAssertNotNil(collectionViewsQuery.buttons["EnterFullScreenButton"])

        
    }
    
    //  Test that checks image content is dynamically populated correctly and also tests the functionality of the images
    //  behaves as expected such as testing when tapped it displays in full screen and the user is able to pan and scroll
    //  the image when it is displayed in full screen mode.
    func testImageContent() {
        
        let app = XCUIApplication()
        
        NSThread.sleepForTimeInterval(15)
        
        let scannerButton = app.tabBars.buttons["Scanner"]
        scannerButton.tap()
        
        let okButton = app.sheets["Input Device Error"].collectionViews.buttons["Ok"]
        okButton.tap()
        
        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("SNneckwear73")
        app.typeText("\r")
        
        NSThread.sleepForTimeInterval(10)
        
        scannerButton.tap()
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
        enterAPassphraseTextField.typeText("POINT-5")
        app.typeText("\r")
        
        NSThread.sleepForTimeInterval(15)
        app.collectionViews.staticTexts["Nuclear Scan"].tap()
        
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.tap()
        element.tap()
        XCTAssertNotNil(element)
        app.buttons["X"].tap()
        XCTAssertNotNil(app.collectionViews.staticTexts["Nuclear Scan"])
        
    }
    
    /// Test to check that text content is correctly shown
    func testTextContent() {
        let app = XCUIApplication()
        
        NSThread.sleepForTimeInterval(15)
        
        let scannerButton = app.tabBars.buttons["Scanner"]
        scannerButton.tap()
        
        let okButton = app.sheets["Input Device Error"].collectionViews.buttons["Ok"]
        okButton.tap()
        
        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("SNneckwear73")
        app.typeText("\r")
        
        NSThread.sleepForTimeInterval(10)
        
        scannerButton.tap()
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
        enterAPassphraseTextField.typeText("POINT-5")
        app.typeText("\r")
        
        NSThread.sleepForTimeInterval(15)
        
        
        let cellsQuery = XCUIApplication().collectionViews.cells
        cellsQuery.otherElements.containingType(.StaticText, identifier:"Nuclear Medicine").childrenMatchingType(.TextView).elementBoundByIndex(0).swipeUp()
        cellsQuery.otherElements.containingType(.StaticText, identifier:"What is nuclear medicine?").childrenMatchingType(.TextView).elementBoundByIndex(1).tap()
        
        XCTAssertNotNil(cellsQuery.otherElements.containingType(.StaticText, identifier:"Nuclear Medicine").childrenMatchingType(.TextView).elementBoundByIndex(0))
        XCTAssertNotNil(cellsQuery.otherElements.containingType(.StaticText, identifier:"Nuclear Medicine").childrenMatchingType(.TextView).elementBoundByIndex(1))
    }

}

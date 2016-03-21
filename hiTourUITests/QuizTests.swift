//
//  QuizTests.swift
//  hiTour
//
//  Created by Charlie Baker on 15/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import XCTest

//  Tests the Quiz functionality
class QuizTests: XCTestCase {
        
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
    
    // Tests the quiz is accessible after all points on the tour have been discovered
    func testQuizAccessible() {
        
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
        enterAPassphraseTextField.typeText("SNPenguins123")
        
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        
        NSThread.sleepForTimeInterval(15)
        
        scannerButton.tap()
        okButton.tap()
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
        enterAPassphraseTextField.typeText("POINT-2")
        app.typeText("\r")
        
        NSThread.sleepForTimeInterval(15)
        
        scannerButton.tap()
        okButton.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("POINT-4")
        app.typeText("\r")
        
        NSThread.sleepForTimeInterval(15)
        
        scannerButton.tap()
        okButton.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("POINT-5")
        doneButton.tap()
        tabBarsQuery.buttons["Feed"].tap()
        XCUIApplication().collectionViews.staticTexts["Feedback Quiz"].tap()
        
        XCTAssertNotNil(app.staticTexts["The Best Quiz"])
    }
    
    // Tests the quiz loads when network connection
    func testQuizFunctionalityWhenNetworkConnection() {
        NSThread.sleepForTimeInterval(15)
        XCTAssertNotNil(XCUIApplication().collectionViews.staticTexts["Feedback Quiz"])
        XCUIApplication().collectionViews.staticTexts["Feedback Quiz"].tap()
        NSThread.sleepForTimeInterval(25)
        
        
        XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        
        XCTAssertNotNil(XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element)
        XCTAssertNotNil(XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element)
        XCTAssertNotNil(XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element)
    }
    
    ///  Tests a quiz can be done and answers submitted
    func testQuizFunctionality() {
        
        let app = XCUIApplication()
        
        NSThread.sleepForTimeInterval(15)
        
        app.collectionViews.staticTexts["Feedback Quiz"].tap()
        
        NSThread.sleepForTimeInterval(25)
        
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        app.buttons["cloud SUBMIT ANSWERS"].tap()
        
        NSThread.sleepForTimeInterval(15)
        
        XCTAssertNotNil(app.staticTexts["Thank You!"])
        XCTAssertNotNil(app.staticTexts["You Scored"])
    }

    
}

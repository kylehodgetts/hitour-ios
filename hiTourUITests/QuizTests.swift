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
        let tabBarsQuery = app.tabBars
        let scannerButton = tabBarsQuery.buttons["Scanner"]
        scannerButton.tap()
        
        let okButton = app.sheets["Input Device Error"].collectionViews.buttons["Ok"]
        okButton.tap()
        
        let enterAPassphraseTextField = app.textFields["\\Ud83d\\Udd11 Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("SNPenguins123")
        
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        app.typeText("\n")
        scannerButton.tap()
        okButton.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("POIT-2")
        app.typeText("\r")
        
        let feedButton = tabBarsQuery.buttons["Feed"]
        feedButton.tap()
        scannerButton.tap()
        okButton.tap()
        okButton.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("POINT-2")
        app.typeText("\r")
        scannerButton.tap()
        okButton.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("POINT-4")
        doneButton.tap()
        app.typeText("\n")
        scannerButton.tap()
        okButton.tap()
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("POINT-5")
        app.typeText("\r")
        feedButton.tap()
        
        XCUIApplication().collectionViews.images["quizicon"].tap()
        
        
        
    }
    
    // Tests the quiz loads when network connection
    func testQuizFunctionalityWhenNetworkConnection() {
        XCUIApplication().collectionViews.images["quizicon"].tap()
        
        
        XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
    }

    
}

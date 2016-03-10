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

    func testPointDiscovery() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tours"].tap()
        app.collectionViews.staticTexts["Imaging Tour: A-Level"].tap()
        tabBarsQuery.buttons["Scanner"].tap()
        
        let okButton = app.sheets["Input Device Error"].collectionViews.buttons["Ok"]
        okButton.tap()
        okButton.tap()
        okButton.tap()
        
        let enterCodeOrPinTextField = app.textFields["Enter Code or PIN"]
        enterCodeOrPinTextField.tap()
        enterCodeOrPinTextField.typeText("2")
        app.buttons["Submit"].tap()
        
        let element = app.scrollViews.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.childrenMatchingType(.TextView).element.pressForDuration(0.5);
        element.childrenMatchingType(.Other).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.TextView).elementBoundByIndex(0).tap()
        element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.TextView).elementBoundByIndex(0).tap()
        tabBarsQuery.buttons["Feed"].tap()
        
    }
    
    func testScannedPointNavigation() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tours"].tap()
        app.collectionViews.staticTexts["Imaging Tour: A-Level"].tap()
        tabBarsQuery.buttons["Scanner"].tap()
        app.sheets["Input Device Error"].collectionViews.buttons["Ok"].tap()
        
        let enterCodeOrPinTextField = app.textFields["Enter Code or PIN"]
        enterCodeOrPinTextField.tap()
        enterCodeOrPinTextField.typeText("3")
        app.buttons["Submit"].tap()
        
        let element = app.scrollViews.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.childrenMatchingType(.TextView).element.tap()
        element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.TextView).elementBoundByIndex(0).tap()
        
    }
    
    
}

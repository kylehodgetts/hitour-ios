//
//  TabletSpecificTest.swift
//  hiTour
//
//  Created by Dominik Kulon on 20/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import XCTest

/// Tests for features that are available only on tablets.
class TabletSpecificTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testScannerDialogShows() {
        let app = XCUIApplication()
        app.navigationBars["hiTour.TabBar"].buttons["Scanner On"].tap()
        
        // In case a camera is not working dismis a popup
        app.tap()
        app.tap()
        
        XCTAssert(app.buttons["Cancel"].exists)
        app.buttons["Cancel"].tap()

    }
    
    func testSegmentedControl() {
        let app = XCUIApplication()
        app.navigationBars["hiTour.TabBar"].buttons["Scanner On"].tap()
        
        // In case a camera is not working dismis a popup
        app.tap()
        app.tap()
        
        app.buttons["Cancel"].tap()
        
        let button = app.navigationBars["hiTour.TabBar"].buttons["Scanner Off"]
        XCTAssert(button.selected)
    }
    
    func testMasterDetailLayout() {
        XCUIDevice.sharedDevice().orientation = .LandscapeRight
        
        let app = XCUIApplication()
        let scannerOnButton = app.navigationBars["hiTour.TabBar"].buttons["Scanner On"]
        scannerOnButton.tap()
        
        // In case a camera is not working dismis a popup
        app.tap()
        app.tap()

        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("SNPenguins123")
        app.typeText("\r")
        
        NSThread.sleepForTimeInterval(5)
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Feed"].tap()
        
        scannerOnButton.tap()
        
        // In case a camera is not working dismis a popup
        app.tap()
        app.tap()
        
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("POINT-4")
        app.typeText("\r")
        
        XCTAssert(app.splitGroups["DetailViewController"].exists)
    }
    
}
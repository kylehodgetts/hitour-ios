//
//  ToursControllerTest.swift
//  hiTour
//
//  Created by Dominik Kulon on 20/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import XCTest

/// Tests for the ToursController checking whether a collection view is populated correctly.
class ToursControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testCollectionView() {        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Scanner"].tap()
        
        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        
        enterAPassphraseTextField.typeText("SNPenguins123")
        app.buttons["Done"].tap()
        
        NSThread.sleepForTimeInterval(5)
        
        tabBarsQuery.buttons["Tours"].tap()
        
        XCTAssert(app.collectionViews.staticTexts["Imaging Tour: University"].exists)
    }

    
    
}
//
//  FeedAdapterTest.swift
//  hiTour
//
//  Created by Dominik Kulon on 20/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import XCTest

/// Tests for the FeedController checking whether a collection view is populated correctly.
class FeedControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testCollectionView() {
        let app = XCUIApplication()
        XCUIDevice.sharedDevice().orientation = .Portrait
        app.tabBars.buttons["Scanner"].tap()
        
        let enterAPassphraseTextField = app.textFields["Enter a passphrase"]
        enterAPassphraseTextField.tap()
        enterAPassphraseTextField.typeText("SNPenguins123")
        app.buttons["Done"].tap()
        
        NSThread.sleepForTimeInterval(5)
        
        XCTAssert(app.collectionViews.staticTexts["Nuclear Medicine"].exists)
    }
    
}
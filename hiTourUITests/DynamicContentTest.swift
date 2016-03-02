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
    
    //  Test that checks the CTScan content has been correctly populated and displayed in the correct order
    func testCTScanContent() {
        let app = XCUIApplication()
        app.collectionViews.images["ctscan"].tap()
        app.staticTexts["Computed tomography"].tap()
        
        XCTAssert(app.staticTexts["Computed tomography"].exists)
        
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        let textView = element.childrenMatchingType(.TextView).element
        textView.tap()
        textView.tap()
        textView.tap()
       
        
        let element3 = element.childrenMatchingType(.Other).elementBoundByIndex(0).childrenMatchingType(.Other).element
        let textView2 = element3.childrenMatchingType(.TextView).elementBoundByIndex(0)
        textView2.tap()
        textView2.tap()
        
        XCTAssert(app.textViews["What Happens In a CT Scan?"].exists)
        XCTAssert(textView2.exists)
        
        element3.childrenMatchingType(.TextView).elementBoundByIndex(1).tap()
        
        let elementsQuery = scrollViewsQuery.otherElements
        let videoElement = elementsQuery.otherElements["Video"]
        videoElement.tap()
        videoElement.tap()
        
        XCTAssert(app.otherElements["Video"].exists)
        
        let element2 = element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element
        element2.childrenMatchingType(.TextView).elementBoundByIndex(0).tap()
        element2.childrenMatchingType(.TextView).elementBoundByIndex(1).tap()
        
        XCTAssert(app.textViews["Image Results of a CT Scan"].exists)
        XCTAssert(app.textViews["Image of a patients scan results from having a CT Scan"].exists)
        elementsQuery.images["mriscanresult1"].tap()
        XCTAssert(app.images["mriscanresult1"].exists)
    }
    
    //  Test that checks the Fluoroscopy content has been dynamically populated correctly
    func testFluroscopyContent() {
        
        let app = XCUIApplication()
        XCTAssert(app.collectionViews.images["fluoroscopy"].exists)
        app.staticTexts["Fluoroscopy Suite"].tap()
        
        XCTAssert(app.staticTexts["Fluoroscopy Suite"].exists)
        
        let element = app.scrollViews.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.childrenMatchingType(.TextView).element.tap()
        XCTAssert(element.exists)
        
        let element2 = element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element2.childrenMatchingType(.TextView).elementBoundByIndex(0).tap()
        element2.childrenMatchingType(.TextView).elementBoundByIndex(1).tap()
        XCTAssert(element2.exists)
        
        let textView = element2.childrenMatchingType(.TextView).elementBoundByIndex(2)
        textView.tap()
        textView.tap()
        XCTAssert(textView.exists)
    }
    
    //  Test that checks the video content is dynamically populated correctly as well as check their controls work
    //  as expected in both normal mode and full screen mode. So that the user is able to control the videos
    func testVideoContent() {
        
        let app = XCUIApplication()
        app.collectionViews.images["ctscan"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        let textView = element.childrenMatchingType(.TextView).element
        textView.tap()
        textView.tap()
        
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["PlayButton"].tap()
        
        let videoElement = elementsQuery.otherElements["Video"]
        videoElement.tap()
        elementsQuery.buttons["PauseButton"].tap()

        XCTAssert(videoElement.exists)
        
        elementsQuery.buttons["EnterFullScreenButton"].tap()
        app.buttons["Play"].tap()
        app.otherElements["Video"].tap()
        app.buttons["pause.button"].tap()
        app.buttons["Done"].tap()
        videoElement.tap()
    }
    
    //  Test that checks image content is dynamically populated correctly and also tests the functionality of the images
    //  behaves as expected such as testing when tapped it displays in full screen and the user is able to pan and scroll
    //  the image when it is displayed in full screen mode.
    func testImageContent() {
        
        let app = XCUIApplication()
        app.collectionViews.images["ctscan"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let textView = scrollViewsQuery.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.TextView).element
        textView.swipeUp()
        textView.tap()
        textView.tap()
        scrollViewsQuery.otherElements.images["mriscanresult1"].tap()
        
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.tap()
        element.tap()
        XCTAssert(element.exists)

        app.buttons["X"].tap()
    }

}

//
//  LocationViewControllerUITests.swift
//  GetGoTestAppUITests
//
//  Created by Chandresh on 21/12/22.
//

import XCTest

class LocationViewControllerUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        XCUIDevice.shared.orientation = .portrait
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewDidLoad() throws {
        let app = XCUIApplication()
        app.launch()
        var device = XCUIDevice.shared.orientation
        device = .portrait // device under test is set to portrait
        XCTAssertTrue(device.isPortrait) // tests if device is in portrait
        app.tabBars["Tab Bar"].buttons["Location"].tap()
        let locationNavigationBar = app.navigationBars["Location"]
        locationNavigationBar.searchFields["Search"].tap()
        locationNavigationBar.buttons["Cancel"].tap()
        let collectionViewsQuery2 = app.collectionViews
        let collectionViewsQuery = collectionViewsQuery2
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Earth (C-137)"]/*[[".cells.staticTexts[\"Earth (C-137)\"]",".staticTexts[\"Earth (C-137)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["https://rickandmortyapi.com/api/character/38"]/*[[".cells.staticTexts[\"https:\/\/rickandmortyapi.com\/api\/character\/38\"]",".staticTexts[\"https:\/\/rickandmortyapi.com\/api\/character\/38\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.navigationBars["Earth (C-137)"].buttons["Cancel"].tap()
        collectionViewsQuery2.children(matching: .cell).element(boundBy: 3).staticTexts["Planet"].swipeUp()
    }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
                XCUIDevice.shared.orientation = .portrait
            }
        }
    }
}

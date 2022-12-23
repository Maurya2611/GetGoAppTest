//
//  EpisodeViewControllerUITests.swift
//  GetGoTestAppUITests
//
//  Created by Chandresh on 23/12/22.
//

import XCTest

class EpisodeViewControllerUITests: XCTestCase {
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
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).staticTexts["season: 01"].tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Episode: 01"]/*[[".cells.staticTexts[\"Episode: 01\"]",".staticTexts[\"Episode: 01\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.navigationBars["Pilot"].buttons["Cancel"].tap()
        let episodeNavigationBar = app.navigationBars["Episode"]
        let searchSearchField = episodeNavigationBar.searchFields["Search"]
        searchSearchField.tap()
        searchSearchField.buttons["Clear text"].tap()
        episodeNavigationBar.buttons["Cancel"].tap()
        app.navigationBars["Anatomy Park"].buttons["Cancel"].tap()
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

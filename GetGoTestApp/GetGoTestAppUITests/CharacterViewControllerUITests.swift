//
//  CharacterViewControllerUITests.swift
//  GetGoTestAppUITests
//
//  Created by Chandresh on 21/12/22.
//

import XCTest

class CharacterViewControllerUITests: XCTestCase {
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
        
        let horizontalScrollBar1PageCollectionView = app.collectionViews.containing(.other, identifier:"Horizontal scroll bar, 1 page").element
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeDown()
        
        let characterNavigationBar = app.navigationBars["Character"]
        characterNavigationBar.searchFields["Search"].tap()
        characterNavigationBar.buttons["Cancel"].tap()
        
        let collectionViewsQuery = app.collectionViews
        let element = collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element
        element.children(matching: .other).element.tap()
        element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element(boundBy: 0).swipeUp()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["https://rickandmortyapi.com/api/episode/27"]/*[[".cells.staticTexts[\"https:\/\/rickandmortyapi.com\/api\/episode\/27\"]",".staticTexts[\"https:\/\/rickandmortyapi.com\/api\/episode\/27\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        app.navigationBars["Rick Sanchez"].buttons["Character"].tap()
        
    }
    func testFilterButton() throws {
        let app = XCUIApplication()
        app.launch()
        var device = XCUIDevice.shared.orientation
        device = .portrait // device under test is set to portrait
        XCTAssertTrue(device.isPortrait) // tests if device is in portrait
        
        app.navigationBars["Character"].buttons["icon filter"].tap()
        let collectionViewsQuery2 = app.collectionViews
        let collectionViewsQuery = collectionViewsQuery2
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Alive"]/*[[".cells.staticTexts[\"Alive\"]",".staticTexts[\"Alive\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Alien"]/*[[".cells.staticTexts[\"Alien\"]",".staticTexts[\"Alien\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Female"]/*[[".cells.staticTexts[\"Female\"]",".staticTexts[\"Female\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Apply"].tap()
        collectionViewsQuery2.cells.children(matching: .other).element.children(matching: .other).element.tap()
        app.navigationBars["Abadango Cluster Princess"].buttons["Character"].tap()
        
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

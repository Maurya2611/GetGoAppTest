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

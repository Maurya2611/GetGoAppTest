//
//  LocationViewControllerTests.swift
//  GetGoTestAppTests
//
//  Created by Chandresh on 24/12/22.
//

import XCTest
@testable import GetGoTestApp
class LocationViewControllerTests: XCTestCase {
    var mockViewModelProtocol: LocationViewModelProtocol!
    var viewModel: LocationViewModel!
    var viewController: LocationViewController!
    private var session = MockURLSession()
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockViewModelProtocol = MockLocationViewModelProtocol()
        viewModel = LocationViewModel.init(delegate: self.mockViewModelProtocol)
        viewController = LocationViewController()
        viewController.viewModel = viewModel
        XCTAssertTrue(viewController.viewModel != nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockViewModelProtocol = nil
        viewModel = nil
        viewController = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testUsingSimpleMock() {
        let router = MockAPIRequest<GetCharcterListApi>(session: session)
        let exp = expectation(description: "Loading URL")
        router.request(.location(page: 0)) { dataModel, response, error in
            exp.fulfill()
            guard let responseData = dataModel else {
                XCTAssertTrue(dataModel == nil)
                return
            }
            do {
                let apiResponse = try LocationDataModel.init(data: responseData)
                XCTAssertTrue(apiResponse.results != nil)
                self.viewModel.locationResult = apiResponse.results ?? []
                self.mockViewModelProtocol.didFetchLocationResult()
                XCTAssertTrue(self.viewModel.locationResult.count > 0)
            } catch {
                print(error)
                self.mockViewModelProtocol.failToFetchLocationResult(error.localizedDescription)
                XCTAssertTrue(!error.localizedDescription.isEmpty)
            }
        }
        // put timeout as per your expectation
        waitForExpectations(timeout: 60) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    // MARK: Referesh Data
    func testRefreshMobileData() {
        viewController.pullToRefresh(UIRefreshControl())
        XCTAssertTrue(viewModel.locationResult.count == 0, "Array isEmpty")
    }
    func testURLEncoding() {
        let scheme = "https"
        let host = "www.google.com"
        let path = "/search"
        let queryItem = URLQueryItem(name: "Chandresh", value: "chandresh@gmail.com")
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]
        guard let fullURL = urlComponents.url else {
            XCTAssertTrue(false, "urlRequest url is nil.")
            return
        }
        let expectedURL = "https://www.google.com/search?Chandresh=chandresh@gmail.com"
        XCTAssertEqual(fullURL.absoluteString.sorted(), expectedURL.sorted())
    }
}

class MockLocationViewModelProtocol: LocationViewModelProtocol {
    private (set) var success = false
    private (set) var failure = false
    private (set) var noData = false
    func noMoreDataToFetch() {
        noData = false
    }
    
    func didFetchLocationResult() {
        success = true
    }
    
    func failToFetchLocationResult(_ error: String?) {
        failure = true
    }
}

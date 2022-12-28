//
//  EpisodeViewControllerTests.swift
//  GetGoTestAppTests
//
//  Created by Chandresh on 24/12/22.
//

import XCTest
@testable import GetGoTestApp

class EpisodeViewControllerTests: XCTestCase {
    var mockViewModelProtocol: MockEpisodesViewModelProtocol!
    var viewModel: EpisodesViewModel!
    var viewController: EpisodesViewController!
    private var session = MockURLSession()
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockViewModelProtocol = MockEpisodesViewModelProtocol()
        viewModel = EpisodesViewModel.init(delegate: self.mockViewModelProtocol)
        viewController = EpisodesViewController()
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
        router.request(.episode(page: 1)) { dataModel, response, error in
            exp.fulfill()
            guard let responseData = dataModel else {
                XCTAssertTrue(dataModel == nil)
                return
            }
            do {
                let apiResponse = try EpisodesDataModel.init(data: responseData)
                XCTAssertTrue(apiResponse.results != nil)
                self.viewModel.episodesResult = apiResponse.results ?? []
                self.mockViewModelProtocol.didFetchEpisodesResult()
                XCTAssertTrue(self.viewModel.episodesResult.count > 0)
            } catch {
                print(error)
                self.mockViewModelProtocol.failToFetchEpisodesResult(error.localizedDescription)
                XCTAssertTrue(!error.localizedDescription.isEmpty)
            }
        }
        // put timeout as per your expectation
        waitForExpectations(timeout: 30, handler: { (error) in
            if let error = error {
                XCTAssertNil(error, "The api request does not give response")
            }
        })
    }
    // MARK: Referesh Data
    func testRefreshMobileData() {
        viewController.pullToRefresh(UIRefreshControl())
        XCTAssertTrue(viewModel.episodesResult.count == 0, "Array isEmpty")
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

class MockEpisodesViewModelProtocol: EpisodesViewModelProtocol {
    private (set) var success = false
    private (set) var failure = false
    private (set) var noData = false
    func noMoreDataToFetch() {
        noData = false
    }
    
    func didFetchEpisodesResult() {
        success = true
    }
    
    func failToFetchEpisodesResult(_ error: String?) {
        failure = true
    }
}

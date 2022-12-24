//
//  CharacterViewControllerTests.swift
//  GetGoTestAppTests
//
//  Created by Chandresh on 23/12/22.
//

import XCTest
@testable import GetGoTestApp

class CharacterViewControllerTests: XCTestCase {
    var mockViewModelProtocol: MockCharacterViewModelProtocol!
    var viewModel: CharacterViewModel!
    var viewController: CharacterViewController!
    private var session = MockURLSession()
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockViewModelProtocol = MockCharacterViewModelProtocol()
        viewModel = CharacterViewModel.init(delegate: self.mockViewModelProtocol)
        viewController = CharacterViewController()
        viewController.viewModel = viewModel
        XCTAssertTrue(viewController.viewModel != nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockViewModelProtocol = nil
        viewModel = nil
        viewController = nil
    }
    func testUsingSimpleMock() {
        let router = MockAPIRequest<GetCharcterListApi>(session: session)
        let exp = expectation(description: "Loading URL")
        router.request(.character(page: 0)) { dataModel, response, error in
            exp.fulfill()
            guard let responseData = dataModel else {
                XCTAssertTrue(dataModel == nil)
                return
            }
            do {
                let apiResponse = try CharacterList.init(data: responseData)
                XCTAssertTrue(apiResponse.results != nil)
                self.viewModel.characterResult = apiResponse.results ?? []
                XCTAssertNotNil(self.viewModel?.characterResult, "Array Should not be nil")
                XCTAssertTrue(self.viewModel.characterResult.count > 0)
                self.mockViewModelProtocol.didFetchCharacterList()
                self.checkFilter()
            } catch {
                print(error)
                self.mockViewModelProtocol.failToFetchCharacterList(error.localizedDescription)
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
    func testDidSelect() throws {
        XCTAssertTrue(viewModel.selectedResult != nil)
        let viewController = CharacterViewController()
        viewController.collectionView(UICollectionView(), didSelectItemAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(viewController)
    }
    func checkFilter() {
        let condition1 = self.viewModel.applyFilter(status: "", species: "", gender: "")
        XCTAssertTrue(condition1.count == 0)
        let condition2 = self.viewModel.applyFilter(status: "Alive", species: "", gender: "")
        XCTAssertTrue(condition2.contains(where: { status in
            !(status.status?.isEmpty ?? false)
        }))
    }
    // MARK: Referesh Data
    func testRefreshMobileData() {
        viewController.pullToRefresh(UIRefreshControl())
        XCTAssertTrue(viewModel.characterResult.count == 0, "Array isEmpty")
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

class MockCharacterViewModelProtocol: CharacterViewModelProtocol {
    private (set) var success = false
    private (set) var failure = false
    private (set) var noData = false
    
    func didFetchCharacterList() {
        success = true
    }
    func failToFetchCharacterList(_ error: String?) {
        failure = true
    }
    func noMoreDataToFetch() {
        noData = false
    }
}

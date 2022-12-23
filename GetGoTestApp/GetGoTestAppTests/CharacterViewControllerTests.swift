//
//  CharacterViewControllerTests.swift
//  GetGoTestAppTests
//
//  Created by Chandresh on 23/12/22.
//

import XCTest
@testable import GetGoTestApp

class CharacterViewControllerTests: XCTestCase {
    var mockCharacterViewModelProtocol: MockCharacterViewModelProtocol!
    var viewModel: CharacterViewModel!
    var viewController: CharacterViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockCharacterViewModelProtocol = MockCharacterViewModelProtocol()
        viewModel = CharacterViewModel.init(delegate: self.mockCharacterViewModelProtocol)
        viewController = CharacterViewController()
        viewController.viewModel = viewModel
        XCTAssertTrue(viewController.viewModel != nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockCharacterViewModelProtocol = nil
        viewModel = nil
        viewController = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    func didFetchCharacterList() {
        
    }
    
    func failToFetchCharacterList(_ error: String?) {
        
    }
    
    func noMoreDataToFetch() {
        
    }
}

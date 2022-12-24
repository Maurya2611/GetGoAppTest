//
//  NetworkRequestTest.swift
//  GetGoTestAppTests
//
//  Created by Chandresh on 24/12/22.
//

import XCTest
@testable import GetGoTestApp

class NetworkRequestTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
protocol MockNetworkRequest: NetworkRouter {

}
protocol MockServerRouter: ServerRouterType {
}
class MockAPIRequest<RouterType: MockServerRouter>: MockNetworkRequest  {
    private var task: URLSessionDataTask?
    private let session: MockURLSession
    init(session: MockURLSession) {
        self.session = session
    }
    func request(_ route: RouterType, completion: @escaping ServerRouterCompletion) {
        do {
           // let request = try NetworkRouter.buildRequest(from: route)
            task = session.dataTask(with: "", completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
}

//extension MockNetworkRequest {
//    func load(_ request: URLRequest, onSuccess: @escaping (ModelType?) -> Void, onError: @escaping (Error?) -> Void?) {
//        
//        let data = self.getData(name: getJsonFileName(request: request))
//        do {
//            try onSuccess(self.decode(data))
//        } catch let parsingError {
//            onError(parsingError)
//            print("Error", parsingError)
//        }
//        
//    }
//    func getJsonFileName(request: URLRequest) -> String {
//        switch request.url?.absoluteString {
//        case ApiRequestUrl.urlString(api: ApiRequestUrl.login):
//            return "login"
//        case ApiRequestUrl.urlString(api: ApiRequestUrl.balances):
//            return "balances"
//        case ApiRequestUrl.urlString(api: ApiRequestUrl.payees):
//            return "payees"
//        case ApiRequestUrl.urlString(api: ApiRequestUrl.transfer):
//            return "transfer"
//        case ApiRequestUrl.urlString(api: ApiRequestUrl.transactions):
//            return "transactions"
//        default:
//            return ""
//        }
//    }
//    func getData(name: String, withExtension: String = "json") -> Data {
//        let bundle = Bundle(for: type(of: self))
//        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
//        let data = try! Data(contentsOf: fileUrl!)
//        return data
//    }
//}

//
//  URLSessionMock.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
@testable import GetGoTestApp


//MARK: MOCK
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}
//MARK: MOCK
class MockURLSession: URLSessionProtocol {
    var nextDataTask: MockURLSessionDataTask = MockURLSessionDataTask()
    var data: Data?
    var error: Error?
    private (set) var lastURL: URL?
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    func dataTask(with request: URLRequest, completionHandler: @escaping ServerRouterCompletion) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(data, successHttpURLResponse(request: request), error)
        return nextDataTask
    }
}
class MockAPIRequest<RouterType: ServerRouterType>: NetworkRouter  {
    private var task: URLSessionDataTaskProtocol?
    private var session: MockURLSession!
    init(session: MockURLSession) {
        self.session = session
    }
    func request(_ route: RouterType, completion: @escaping ServerRouterCompletion) {
        do {
            let bundle = Bundle(for: type(of: self))
            guard let fileUrl = bundle.url(forResource: route.path, withExtension: "json") else { return  }
            let jsonData = try Data(contentsOf: fileUrl).base64EncodedData()
            completion(jsonData, nil, nil)
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
}

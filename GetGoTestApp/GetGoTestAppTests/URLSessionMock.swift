//
//  URLSessionMock.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
@testable import GetGoTestApp


// Second Attempt
class DataTaskMock: URLSessionDataTask {
    private (set) var resumeWasCalled = false
    override func resume() {
        resumeWasCalled = true
    }
}
//MARK: MOCK
class MockURLSession: URLSessionProtocol {
    var nextDataTask: DataTaskMock = DataTaskMock()
    var data: Data?
    var error: Error?
    private (set) var lastURL: URL?
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    func dataTask(with request: URLRequest, completionHandler: @escaping ServerRouterCompletion) -> URLSessionDataTask {
        lastURL = request.url
        completionHandler(data, successHttpURLResponse(request: request), error)
        return nextDataTask
    }
}

//  NetworkService.swift
//  NetworkLayer
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//
import Foundation
public typealias ServerRouterCompletion = (_ dataModel: Data?, _ response: URLResponse?, _ error: Error?) -> Void
protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: ServerRouterType
    func request(_ route: EndPoint, completion: @escaping ServerRouterCompletion)
}
// MARK: - Protocol for MOCK/Real
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping ServerRouterCompletion) -> URLSessionDataTaskProtocol
}
protocol URLSessionDataTaskProtocol {
    func resume()
}
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping ServerRouterCompletion) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class BaseNetworkRouter<RouterType: ServerRouterType>: NetworkRouter {
    private var task: URLSessionDataTaskProtocol?
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }
    func request(_ route: RouterType, completion: @escaping ServerRouterCompletion) {
        do {
            let request = try self.buildRequest(from: route)
            ServerLogs.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    func buildRequest(from route: RouterType) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10)
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters): try self.configureParameters(bodyParameters: bodyParameters,
                                                                                     bodyEncoding: bodyEncoding,
                                                                                     urlParameters: urlParameters,
                                                                                     request: &request)
            case .requestParametersWithHeaders(let bodyParameters,
                                               let bodyEncoding,
                                               let urlParameters,
                                               let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

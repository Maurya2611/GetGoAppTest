//
//  BaseURLWithRouterType.swift
//  NetworkLayer
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//
import Foundation
enum ServerEnvironment {
    case staging
}
public enum GetCharcterListApi {
    case character(page: Int)
    case location(page: Int)
    case episode(page: Int)
   // case characterWithID(id: Int)
}
extension GetCharcterListApi: ServerRouterType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .staging: return "https://rickandmortyapi.com/api/"
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    var path: String {
        switch self {
        case .character:
            return "character"
        case .location:
            return "location"
        case .episode:
            return "episode"
        }
    }
    var httpMethod: HTTPMethod {
        return .get
    }
    var task: HTTPTask {
        switch self {
        case .character(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page": page])
        case .location(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page": page])
        case .episode(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page": page])
        }
    }
    var headers: HTTPHeaders? {
        return nil
    }
}

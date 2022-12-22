//
//  HTTPTask.swift
//  NetworkLayer
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//

import Foundation
public typealias HTTPHeaders = [String: String]
public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    case requestParametersWithHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    // case download, upload...etc
}

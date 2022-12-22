//
//  LocationDataModel.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//

import Foundation

// MARK: - LocationDataModel
struct LocationDataModel: Codable {
    let info: Info?
    let results: [LocationDataResult]?
    
    enum CodingKeys: String, CodingKey {
        case info = "info"
        case results = "results"
    }
}

// MARK: LocationDataModel convenience initializers and mutators
extension LocationDataModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(LocationDataModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(info: Info?? = nil,
              results: [LocationDataResult]?? = nil) -> LocationDataModel {
        return LocationDataModel(
            info: info ?? self.info,
            results: results ?? self.results)
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Result LocationDataResult
struct LocationDataResult: Codable {
    let id: Int?
    let name: String?
    let type: String?
    let dimension: String?
    let residents: [String]?
    let url: String?
    let created: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case dimension = "dimension"
        case residents = "residents"
        case url = "url"
        case created = "created"
    }
}

// MARK: Result LocationDataList convenience initializers and mutators
extension LocationDataResult {
    init(data: Data) throws {
        self = try JSONDecoder().decode(LocationDataResult.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(id: Int?? = nil, name: String?? = nil, type: String?? = nil,
              dimension: String?? = nil, residents: [String]?? = nil, url: String?? = nil,
              created: String?? = nil) -> LocationDataResult {
        return LocationDataResult(id: id ?? self.id,
                                name: name ?? self.name, type: type ?? self.type,
                                dimension: dimension ?? self.dimension, residents: residents ?? self.residents,
                                url: url ?? self.url, created: created ?? self.created)
    }
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

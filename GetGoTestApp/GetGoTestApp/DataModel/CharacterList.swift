//
//  CharacterList.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//

import Foundation
//   let characterList = try CharacterList(json)
// MARK: - CharacterList
struct CharacterList: Codable {
    let info: Info?
    let results: [CharacterResult]?
    
    enum CodingKeys: String, CodingKey {
        case info = "info"
        case results = "results"
    }
}

// MARK: CharacterList convenience initializers and mutators
extension CharacterList {
    init(data: Data) throws {
        self = try JSONDecoder().decode(CharacterList.self, from: data)
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
    
    func with(info: Info?? = nil, results: [CharacterResult]?? = nil) -> CharacterList {
        return CharacterList(info: info ?? self.info,
                             results: results ?? self.results)
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Info
struct Info: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case pages = "pages"
        case next = "next"
        case prev = "prev"
    }
}

// MARK: Info convenience initializers and mutators

extension Info {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Info.self, from: data)
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
    
    func with(count: Int?? = nil, pages: Int?? = nil,
              next: String?? = nil, prev: String?? = nil) -> Info {
        return Info(count: count ?? self.count,
                    pages: pages ?? self.pages, next: next ?? self.next, prev: prev ?? self.prev)
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Result
struct CharacterResult: Codable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin: Origin?
    let location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case type = "type"
        case gender = "gender"
        case origin = "origin"
        case location = "location"
        case image = "image"
        case episode = "episode"
        case url = "url"
        case created = "created"
    }
}

// MARK: Result convenience initializers and mutators
extension CharacterResult {
    init(data: Data) throws {
        self = try JSONDecoder().decode(CharacterResult.self, from: data)
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
    
    func with(id: Int?? = nil, name: String?? = nil,
              status: String?? = nil, species: String?? = nil,
              type: String?? = nil, gender: String?? = nil,
              origin: Origin?? = nil, location: Location?? = nil,
              image: String?? = nil, episode: [String]?? = nil,
              url: String?? = nil, created: String?? = nil) -> CharacterResult {
        return CharacterResult(id: id ?? self.id,
                               name: name ?? self.name, status: status ?? self.status,
                               species: species ?? self.species, type: type ?? self.type,
                               gender: gender ?? self.gender, origin: origin ?? self.origin,
                               location: location ?? self.location, image: image ?? self.image,
                               episode: episode ?? self.episode, url: url ?? self.url,
                               created: created ?? self.created)
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Location
struct Location: Codable {
    let name: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}
// MARK: Location convenience initializers and mutators
extension Location {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Location.self, from: data)
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
    
    func with(name: String?? = nil, url: String?? = nil) -> Location {
        return Location(name: name ?? self.name, url: url ?? self.url)
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
// MARK: - Location
struct Origin: Codable {
    let name: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

// MARK: Location convenience initializers and mutators
extension Origin {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Origin.self, from: data)
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
    
    func with(name: String?? = nil, url: String?? = nil) -> Origin {
        return Origin(name: name ?? self.name, url: url ?? self.url)
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

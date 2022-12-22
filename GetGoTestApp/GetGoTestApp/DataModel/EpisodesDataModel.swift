//
//  EpisodesDataModel.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//

import Foundation

// MARK: - EpisodesDataModel
struct EpisodesDataModel: Codable {
    let info: Info?
    let results: [EpisodesDataResult]?

    enum CodingKeys: String, CodingKey {
        case info = "info"
        case results = "results"
    }
}

// MARK: EpisodesDataModel convenience initializers and mutators

extension EpisodesDataModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(EpisodesDataModel.self, from: data)
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
        results: [EpisodesDataResult]?? = nil) -> EpisodesDataModel {
        return EpisodesDataModel(info: info ?? self.info,
            results: results ?? self.results)
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Result
struct EpisodesDataResult: Codable {
    let id: Int?
    let name: String?
    let airDate: String?
    let episode: String?
    let characters: [String]?
    let url: String?
    let created: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case airDate = "air_date"
        case episode = "episode"
        case characters = "characters"
        case url = "url"
        case created = "created"
    }
}

// MARK: Result convenience initializers and mutators

extension EpisodesDataResult {
    init(data: Data) throws {
        self = try JSONDecoder().decode(EpisodesDataResult.self, from: data)
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

    func with(id: Int?? = nil,
        name: String?? = nil,
        airDate: String?? = nil,
        episode: String?? = nil,
        characters: [String]?? = nil,
        url: String?? = nil,
        created: String?? = nil) -> EpisodesDataResult {
        return EpisodesDataResult(id: id ?? self.id,
            name: name ?? self.name,
            airDate: airDate ?? self.airDate,
            episode: episode ?? self.episode,
            characters: characters ?? self.characters,
            url: url ?? self.url,
            created: created ?? self.created)
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

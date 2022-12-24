//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//
import Foundation
import UIKit
enum ServerResponse: String {
    case success
    case badRequest = "Bad request"
    case failedToFetch = "Failed to fetch from Server"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}
enum Result<String> {
    case success
    case failure(String)
}
struct NetworkManager {
    static let environment: ServerEnvironment = .staging
    let router = BaseNetworkRouter<GetCharcterListApi>(session: URLSession.shared)
    func fetchCharacterListData(page: Int, completion: @escaping (_ dataModel: CharacterList?, _ error: String?) -> Void) {
        router.request(.character(page: page)) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                switch self.handleNetworkResponse(response) {
                case .success:
                    guard let responseData = data else {
                        completion(nil, ServerResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let apiResponse = try CharacterList.init(data: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        print(error)
                        completion(nil, ServerResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    func fetchLocationDataList(page: Int, completion: @escaping (_ dataModel: LocationDataModel?, _ error: String?) -> Void) {
        router.request(.location(page: page)) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                switch self.handleNetworkResponse(response) {
                case .success:
                    guard let responseData = data else {
                        completion(nil, ServerResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let apiResponse = try LocationDataModel.init(data: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        print(error)
                        completion(nil, ServerResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    func fetchEpisodesDataList(page: Int,
                               completion: @escaping (_ dataModel: EpisodesDataModel?, _ error: String?) -> Void) {
        router.request(.episode(page: page)) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                switch self.handleNetworkResponse(response) {
                case .success:
                    guard let responseData = data else {
                        completion(nil, ServerResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let apiResponse = try EpisodesDataModel.init(data: responseData)
                        print(apiResponse.info?.pages ?? "")
                        completion(apiResponse, nil)
                    } catch {
                        print(error)
                        completion(nil, ServerResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(ServerResponse.failedToFetch.rawValue)
        case 501...599: return .failure(ServerResponse.badRequest.rawValue)
        case 600: return .failure(ServerResponse.outdated.rawValue)
        default: return .failure(ServerResponse.failed.rawValue)
        }
    }
}

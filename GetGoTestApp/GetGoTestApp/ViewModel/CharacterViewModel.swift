//
//  CharacterViewModel.swift
//  GetGoTestApp
//
//  Created by Chandresh on 17/12/22.
//

import Foundation
// MARK: - Protocols
protocol CharacterViewModelProtocol: AnyObject {
    func didFetchCharacterList()
    func failToFetchCharacterList(_ error: String?)
    func noMoreDataToFetch()
}
public class CharacterViewModel {
    private weak var delegate: CharacterViewModelProtocol?
    var characterResult: [CharacterResult] = [CharacterResult]()
    var filteredResult: [CharacterResult] = []
    var selectedResult: CharacterResult?
    private let networkManager: NetworkManager = NetworkManager()
    var page: Int = 1
    var totalPages: Int = 1
    init(delegate: CharacterViewModelProtocol?) {
        self.delegate = delegate
    }
}
extension CharacterViewModel {
    func fetchCharacterListData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.networkManager.fetchCharacterListData(page: self.page, completion: { characterData, error in
                if let serverError = error {
                    self.delegate?.failToFetchCharacterList(serverError)
                } else {
                    DispatchQueue.main.async {
                        guard let responseData = characterData else {
                            return
                        }
                        self.characterResult += responseData.results ?? self.characterResult
                        self.page += 1
                        self.totalPages = responseData.info?.pages ?? 1
                        self.delegate?.didFetchCharacterList()
                    }
                }
            })
        }
    }
    func loadMoreData() {
        if CommonUtils.shouldLoadMoreData(totalPage: self.totalPages, totalPageLoaded: self.page) {
            self.fetchCharacterListData()
        } else {
            self.delegate?.noMoreDataToFetch()
        }
    }
    func applyFilter(status: String, species: String, gender: String) -> [CharacterResult] {
        let filteredArray = self.characterResult.filter { $0.status == status && $0.species == species && $0.gender == gender}
        return filteredArray
    }
}

//
//  EpisodesViewModel.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//

import Foundation
// MARK: - Protocols
protocol EpisodesViewModelProtocol: AnyObject {
    func didFetchEpisodesResult()
    func failToFetchEpisodesResult(_ error: String?)
    func noMoreDataToFetch()
}
public class EpisodesViewModel {
    private weak var delegate: EpisodesViewModelProtocol?
    var episodesResult: [EpisodesDataResult] = [EpisodesDataResult]()
    var filteredResult: [EpisodesDataResult] = []
    var selectedResult: EpisodesDataResult?
    private let networkManager: NetworkManager = NetworkManager()
    var page: Int = 1
    var totalPages: Int = 10
    init(delegate: EpisodesViewModelProtocol?) {
        self.delegate = delegate
    }
}
extension EpisodesViewModel {
    func fetchEpisodesDataResult() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.networkManager.fetchEpisodesDataList(page: self.page, completion: { episodeData, error in
                if let serverError = error {
                    self.delegate?.failToFetchEpisodesResult(serverError)
                } else {
                    DispatchQueue.main.async {
                        guard let responseData = episodeData else {
                            return
                        }
                        self.episodesResult += responseData.results ?? self.episodesResult
                        self.page += 1
                        self.delegate?.didFetchEpisodesResult()
                    }
                }
            })
        }
    }
    func loadMoreData() {
        if CommonUtils.shouldLoadMoreData(totalPage: self.totalPages, totalPageLoaded: self.page) {
            self.fetchEpisodesDataResult()
        } else {
            self.delegate?.noMoreDataToFetch()
        }
    }
}

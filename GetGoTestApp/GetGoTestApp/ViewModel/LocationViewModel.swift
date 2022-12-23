//
//  LocationViewModel.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//

import Foundation
// MARK: - Protocols
protocol LocationViewModelProtocol: AnyObject {
    func didFetchLocationResult()
    func failToFetchLocationResult(_ error: String?)
    func noMoreDataToFetch()
}
public class LocationViewModel {
    private weak var delegate: LocationViewModelProtocol?
    var locationResult: [LocationDataResult] = [LocationDataResult]()
    var filteredResult: [LocationDataResult] = []
    var selectedResult: LocationDataResult?
    private let networkManager: NetworkManager = NetworkManager()
    var page: Int = 1
    var totalPages: Int = 10
    init(delegate: LocationViewModelProtocol?) {
        self.delegate = delegate
    }
}
extension LocationViewModel {
    func fetchLocationDataResult() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.networkManager.fetchLocationDataList(page: self.page, completion: { locationData, error in
                if let serverError = error {
                    self.delegate?.failToFetchLocationResult(serverError)
                } else {
                    DispatchQueue.main.async {
                        guard let responseData = locationData else {
                            return
                        }
                        self.locationResult += responseData.results ?? self.locationResult
                        self.page += 1
                        self.delegate?.didFetchLocationResult()
                    }
                }
            })
        }
    }
    func loadMoreData() {
        if CommonUtils.shouldLoadMoreData(totalPage: self.totalPages, totalPageLoaded: self.page) {
            self.fetchLocationDataResult()
        } else {
            self.delegate?.noMoreDataToFetch()
        }
    }
}

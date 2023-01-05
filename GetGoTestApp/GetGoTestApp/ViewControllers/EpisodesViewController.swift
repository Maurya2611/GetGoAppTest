//
//  EpisodesViewController.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.

import Foundation
import UIKit
// MARK: - EpisodesViewController
class EpisodesViewController: UIViewController {
    var viewModel: EpisodesViewModel?
    private let padding: CGFloat = 16
    private let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 16,
                                                          left: 16,
                                                          bottom: 0,
                                                          right: 16)
    
    // MARK: - UICollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(EpisodesFeedCell.nib, forCellWithReuseIdentifier: EpisodesFeedCell.reuseIdentifier)
        view.dataSource = self
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.bounces = true
        view.backgroundColor = .clear
        return view
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.addTarget(self,
                          action: #selector(pullToRefresh(_:)),
                          for: .valueChanged)
        refresh.tintColor = .black
        return refresh
    }()
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    // MARK: - UISearchController
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .default
        searchController.definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = .black
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black]
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "",
                                                                 attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.gray
            }
        }
        return searchController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EpisodesViewModel(delegate: self)
        self.view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -(padding / 3)).isActive = true
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        
        // service API Call
        if NetworkReachability.isInterNetExist() {
            CommonUtils.showOnLoader(in: self.view)
            viewModel?.fetchEpisodesDataResult()
        } else {
            CommonUtils.hideOffLoader()
            CommonUtils.showAlert(in: self, withTitle: "No Internet connection!",
                                  withBodyMessage: "Turn on mobile data or use Wi-Fi to access data.")
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    @objc func pullToRefresh(_ control: UIRefreshControl) {
        self.refreshControl.endRefreshing()
        DispatchQueue.main.async {
            self.viewModel?.fetchEpisodesDataResult()
        }
    }
    func showEpisodeDetailViewController() {
        if let viewModel = self.viewModel, viewModel.selectedResult != nil   {
            let viewController = EpisodeDetailViewController.init(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .pageSheet
            navigationController.navigationBar.isTranslucent = true
            self.present(navigationController, animated: true)
        }
    }

}
// MARK: - UISearchBarDelegate, UISearchResultsUpdating
extension EpisodesViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0,
              let result = self.viewModel?.episodesResult else {
            self.searchBarCancelButtonClicked(searchController.searchBar)
            return
        }
        let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [searchText])
        self.viewModel?.filteredResult = result.filter { filterPredicate.evaluate(with: $0.name) }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel?.filteredResult.removeAll()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
// MARK: - UICollectioViewDataSource methods
extension EpisodesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering && self.viewModel?.filteredResult.count ?? 0 > 0 {
            return self.viewModel?.filteredResult.count ?? 0
        }
        return self.viewModel?.episodesResult.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodesFeedCell.reuseIdentifier,
                                                            for: indexPath) as? EpisodesFeedCell  else {
            return UICollectionViewCell()
        }
        var item = viewModel?.episodesResult[indexPath.row]
        if isFiltering && self.viewModel?.filteredResult.count ?? 0 > 0 {
            item = viewModel?.filteredResult[indexPath.row]
        }
        cell.bind(item)
        return cell
    }
}
extension EpisodesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (padding * 2),
                      height: EpisodesFeedCell.cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let count = viewModel?.episodesResult.count, indexPath.row == count - 1 {
            // this is the last cell, load more data
            if NetworkReachability.isInterNetExist() {
                CommonUtils.showOnLoader(in: self.view)
                viewModel?.loadMoreData()
            } else {
                CommonUtils.hideOffLoader()
                CommonUtils.showAlert(in: self, withTitle: "No Internet connection!",
                                      withBodyMessage: "Turn on mobile data or use Wi-Fi to access data.")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = viewModel?.episodesResult[indexPath.row] {
            viewModel?.selectedResult = item
            showEpisodeDetailViewController()
        }
    }
}
// MARK: - Result for API calls methods
extension EpisodesViewController: EpisodesViewModelProtocol {
    func didFetchEpisodesResult() {
        CommonUtils.hideOffLoader()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func failToFetchEpisodesResult(_ error: String?) {
        CommonUtils.hideOffLoader()
        CommonUtils.showAlert(in: self, withTitle: "GetGoAlert!", withBodyMessage: error)
    }
    func noMoreDataToFetch() {
        CommonUtils.hideOffLoader()
        CommonUtils.showAlert(in: self, withTitle: "GetGoAlert!", withBodyMessage: "No More Data to Load....")
    }
}


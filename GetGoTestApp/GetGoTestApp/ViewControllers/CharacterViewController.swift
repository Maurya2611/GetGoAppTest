//
//  CharacterViewController.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//

import Foundation
import UIKit
// MARK: - UIViewController
class CharacterViewController: UIViewController {
    private let sheetTransitioningDelegate = SheetTransitioningDelegate()
    var viewModel: CharacterViewModel?
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
        view.register(CharacterFeedCell.nib, forCellWithReuseIdentifier: CharacterFeedCell.reuseIdentifier)
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
        return CommonUtils.searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return CommonUtils.searchController.isActive && !isSearchBarEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CharacterViewModel(delegate: self)
        self.view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -(padding / 3)).isActive = true
        navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_filter"),
                                                                 style: .plain, target: self,
                                                                 action: #selector(filterButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // service API Call
        if NetworkReachability.isInterNetExist() {
            CommonUtils.showOnLoader(in: self.view)
            viewModel?.fetchCharacterListData()
        } else {
            CommonUtils.hideOffLoader()
            CommonUtils.showAlert(in: self, withTitle: "No Internet connection!",
                                  withBodyMessage: "Turn on mobile data or use Wi-Fi to access data.")
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonUtils.searchController.searchBar.delegate = self
        CommonUtils.searchController.searchResultsUpdater = self
        self.navigationItem.searchController = CommonUtils.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    @objc func pullToRefresh(_ control: UIRefreshControl) {
        self.refreshControl.endRefreshing()
        DispatchQueue.main.async {
            self.viewModel?.fetchCharacterListData()
        }
    }
    @objc func filterButtonPressed(_ sender: Any) {
        if let viewModel = self.viewModel, viewModel.characterResult.count > 0 {
            let viewController = FilterViewController.init(viewModel: viewModel)
            viewController.delegate = self
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = sheetTransitioningDelegate
            self.present(viewController, animated: true)
        }
    }
    func showDetailCharacterViewController() {
        if let viewModel = self.viewModel, viewModel.selectedResult != nil   {
            let viewController = CharacterDetailViewController.init(viewModel: viewModel)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func checkFilterButtonEnable() {
        if let viewModel = self.viewModel, viewModel.characterResult.count > 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
extension CharacterViewController: FilterViewControllerProtocol {
    func didFetchFilterDataList(_ status: String?, _ spices: String?, _ gender: String?) {
        let filterArray = viewModel?.applyFilter(status: status ?? "", species: spices ?? "", gender: gender ?? "")
        viewModel?.characterResult = filterArray ?? []
        print(filterArray ?? "")
        collectionView.reloadData()
    }
}
// MARK: - UISearchBarDelegate, UISearchResultsUpdating
extension CharacterViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0,
              let result = self.viewModel?.characterResult else {
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
extension CharacterViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering && self.viewModel?.filteredResult.count ?? 0 > 0 {
            return self.viewModel?.filteredResult.count ?? 0
        }
        return self.viewModel?.characterResult.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterFeedCell.reuseIdentifier,
                                                            for: indexPath) as? CharacterFeedCell  else {
            return UICollectionViewCell()
        }
        var item = viewModel?.characterResult[indexPath.row]
        if isFiltering && self.viewModel?.filteredResult.count ?? 0 > 0 {
            item = viewModel?.filteredResult[indexPath.row]
        }
        cell.bind(item)
        return cell
    }
}
extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - ((padding / 2) + padding),
                      height: CharacterFeedCell.cellHeight)
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
//        if let count = viewModel?.characterResult.count, indexPath.row == count - 1 {
//            // this is the last cell, load more data
//            if NetworkReachability.isInterNetExist() {
//                CommonUtils.showOnLoader(in: self.view)
//                viewModel?.loadMoreData()
//            } else {
//                CommonUtils.hideOffLoader()
//                CommonUtils.showAlert(in: self, withTitle: "No Internet connection!",
//                                      withBodyMessage: "Turn on mobile data or use Wi-Fi to access data.")
//            }
//        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = viewModel?.characterResult[indexPath.row] {
            viewModel?.selectedResult = item
            showDetailCharacterViewController()
        }
    }
}
// MARK: - Result for API calls methods
extension CharacterViewController: CharacterViewModelProtocol {
    func didFetchCharacterList() {
        CommonUtils.hideOffLoader()
        checkFilterButtonEnable()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func failToFetchCharacterList(_ error: String?) {
        CommonUtils.hideOffLoader()
        CommonUtils.showAlert(in: self, withTitle: "GetGoAlert!", withBodyMessage: error)
    }
    
    func noMoreDataToFetch() {
        CommonUtils.hideOffLoader()
        CommonUtils.showAlert(in: self, withTitle: "GetGoAlert!", withBodyMessage: "No More Data to Load....")
    }
}

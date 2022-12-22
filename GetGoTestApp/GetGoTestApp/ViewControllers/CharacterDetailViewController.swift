//
//  CharacterDetailViewController.swift
//  GetGoTestApp
//
//  Created by Chandresh on 19/12/22.
//

import Foundation
import UIKit

class CharacterDetailViewController: UIViewController {
    var viewModel: CharacterViewModel?
    private let padding: CGFloat = 16
    private let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0,
                                                          left: 16,
                                                          bottom: 0,
                                                          right: 16)
    // MARK: - UICollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CharacterDetailFeedCell.nib, forCellWithReuseIdentifier: CharacterDetailFeedCell.reuseIdentifier)
        view.register(CommonLinkFeedCell.nib, forCellWithReuseIdentifier: CommonLinkFeedCell.reuseIdentifier)
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: UICollectionView.elementKindSectionHeader)
        view.dataSource = self
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.bounces = true
        view.backgroundColor = .clear
        return view
    }()
    
    init(viewModel: CharacterViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
     }
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         fatalError("init(coder:) has not been implemented")
     }
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.selectedResult?.name
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 2).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.navigationItem.largeTitleDisplayMode = .never
        self.tabBarController?.tabBar.isHidden = true

    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed, isMovingFromParent {
            self.tabBarController?.tabBar.isHidden = false
        }
    }

}
// MARK: - UICollectioViewDataSource methods
extension CharacterDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = viewModel?.selectedResult?.episode?.count, count > 0 && section == 1 {
            return count
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailFeedCell.reuseIdentifier,
                                                                for: indexPath) as? CharacterDetailFeedCell  else {
                return UICollectionViewCell()
            }
            cell.bind(viewModel?.selectedResult)
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonLinkFeedCell.reuseIdentifier, for: indexPath) as? CommonLinkFeedCell  else {
            return UICollectionViewCell()
        }
        if viewModel?.selectedResult?.episode?.count ?? 0 > 0 {
            if let item = viewModel?.selectedResult?.episode?[indexPath.row] {
                cell.bind(item)
            }
        } else {
            cell.bind("No record found...!")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: kind, for: indexPath)
            
            headerView.backgroundColor = UIColor.white
            let heardertitle = UILabel.init(frame: CGRect(x: padding, y: 0,
                                                          width: collectionView.frame.width - (padding * 2), height: 44))
            heardertitle.textColor = .black
            heardertitle.text = "Episode:"
            heardertitle.font = UIFont(name:"SFProRounded-Semibold",size: 20) ?? UIFont.boldSystemFont(ofSize: 14)
            headerView.addSubview(heardertitle)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width - (padding * 2),
                          height: CharacterDetailFeedCell.cellHeight)
        }
        return CGSize(width: collectionView.frame.width - (padding * 2),
                      height: CommonLinkFeedCell.cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 44)
        }
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 0,
                                left: 16,
                                bottom: 0,
                                right: 16)
        }
        return sectionInset
    }
}

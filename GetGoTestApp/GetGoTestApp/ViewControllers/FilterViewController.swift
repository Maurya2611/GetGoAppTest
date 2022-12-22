//
//  FilterViewController.swift
//  GetGoTestApp
//
//  Created by Chandresh on 21/12/22.
//

import Foundation
import UIKit
// MARK: - FilterViewController
class FilterViewController: UIViewController {
    var viewModel: CharacterViewModel?
    private let padding: CGFloat = 8
    private let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0,
                                                          left: 16,
                                                          bottom: 10,
                                                          right: 16)
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: layout)
        view.register(FilterCharacterTagCell.nib, forCellWithReuseIdentifier: FilterCharacterTagCell.reuseIdentifier)
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: UICollectionView.elementKindSectionHeader)
        view.isScrollEnabled = false
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
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
        self.title = "Filter"
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 2).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tabBarController?.tabBar.isHidden = true
    }
    private func estimatedFrame(text: String) -> CGRect {
        let font = [NSAttributedString.Key.font: UIFont(name:"SFProRounded-Semibold", size: 14)
                     ?? UIFont.boldSystemFont(ofSize: 14)]
        let size = CGSize(width: .greatestFiniteMagnitude, height: FilterCharacterTagCell.cellHeight)
        return text.boundingRect(with: size,
                                 options: .usesLineFragmentOrigin,
                                 attributes: font,
                                 context: nil)
    }
}
// MARK: - UICollectioViewDataSource methods
extension FilterViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCharacterTagCell.reuseIdentifier,
                                                            for: indexPath) as? FilterCharacterTagCell  else {
            return UICollectionViewCell()
        }
        cell.bind("demo")
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
            heardertitle.font = UIFont(name:"SFProRounded-Semibold", size: 20) ?? UIFont.boldSystemFont(ofSize: 14)
            headerView.addSubview(heardertitle)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
extension FilterViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGRect = collectionView.frame
        if let text = self.viewModel?.selectedResult?.status {
            size = self.estimatedFrame(text: text)
        }
        return CGSize(width: size.width > 0 ? size.width : (size.width / 4) - (padding * 2) ,
                      height: FilterCharacterTagCell.cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
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
}

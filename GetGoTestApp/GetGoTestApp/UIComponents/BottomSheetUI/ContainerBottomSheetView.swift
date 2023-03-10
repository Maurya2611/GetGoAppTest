//
//  ContainerBottomSheetView.swift.swift
//  GetGoTestApp
//
//  Created by Chandresh on 22/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//
import UIKit

final class ContainerBottomSheetView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter"
        label.textColor = .black
        label.font = UIFont(name:"SFProRounded-Semibold", size: 30) ?? UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = .tintColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font =  UIFont(name:"SFProRounded-Semibold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(applyButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var selectedValue: [String: String] = [:]
    // MARK: - UI Elements
    private let padding: CGFloat = 8
    private let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0,
                                                          left: 8,
                                                          bottom: 10,
                                                          right: 8)
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: layout)
        view.register(FilterCharacterTagCell.nib, forCellWithReuseIdentifier: FilterCharacterTagCell.reuseIdentifier)
        view.register(CollectionHeaderView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: CollectionHeaderView.reuseIdentifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.allowsMultipleSelection = true
        return view
    }()
    
    // MARK: - Interactions
    var didTapButton: (([String: String]) -> Void)?
    var listItems: Array<Any>?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SSUL
    
    private func setup() {
        self.backgroundColor = .white
        addSubview(button)
        addSubview(titleLabel)
        self.addSubview(collectionView)
    }
    @objc func applyButtonPressed(_ sender: Any) {
        self.didTapButton?(self.selectedValue)
    }
    private func layout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height / 1.5))
        ])
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24),
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    private func estimatedFrame(text: String) -> CGRect {
        let font = [NSAttributedString.Key.font: UIFont(name:"SFProRounded-Semibold", size: 14)
                    ?? UIFont.boldSystemFont(ofSize: 14)]
        let size = CGSize(width: .greatestFiniteMagnitude, height: FilterCharacterTagCell.cellHeight)
        return text.boundingRect(with: size,
                                 options: .usesFontLeading,
                                 attributes: font,
                                 context: nil)
    }
}

// MARK: - UICollectioViewDataSource methods
extension ContainerBottomSheetView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listItems?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsObject: [String: Any] = listItems?[section] as? [String: Any] ?? [:]
        let items: Array<Any> = itemsObject["list"] as? Array<Any> ?? []
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCharacterTagCell.reuseIdentifier,
                                                            for: indexPath) as? FilterCharacterTagCell  else {
            return UICollectionViewCell()
        }
        if let itemsObject = listItems?[indexPath.section] as? [String: Any],
           let items = itemsObject["list"] as? Array<Any>,
           let cellValue = items[indexPath.row] as? String, let keyValue = itemsObject["title"] as? String {
            cell.bind(cellValue)
            if cellValue ==  selectedValue[keyValue]{
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: CollectionHeaderView.reuseIdentifier,
                                                                                   for: indexPath) as? CollectionHeaderView else {
                return UICollectionReusableView()
            }
            if let itemsObject = listItems?[indexPath.section] as? [String: Any],
               let title = itemsObject["title"] as? String {
                headerView.titleLabel.text = title
            }
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: false)
        })
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let itemsObject = listItems?[indexPath.section] as? [String: Any], let keyValue = itemsObject["title"] as? String {
            selectedValue.removeValue(forKey: keyValue)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let itemsObject = listItems?[indexPath.section] as? [String: Any],
           let items = itemsObject["list"] as? Array<Any>, let strValue = items[indexPath.row] as? String,
            let keyValue = itemsObject["title"] as? String {
            selectedValue[keyValue] = strValue
        }
    }
}
extension ContainerBottomSheetView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGRect = collectionView.frame
        if let itemsObject = listItems?[indexPath.section] as? [String: Any],
           let items = itemsObject["list"] as? Array<Any>, let name = items[indexPath.row] as? String {
            size = self.estimatedFrame(text: name)
        }
        return CGSize(width: size.width > 0 ? size.width + (padding * 2): (size.width / 4) - (padding * 2) ,
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


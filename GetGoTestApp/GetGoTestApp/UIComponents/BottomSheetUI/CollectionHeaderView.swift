//
//  CollectionHeaderView.swift
//  GetGoTestApp
//
//  Created by Chandresh on 22/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//

import Foundation
import UIKit
public class CollectionHeaderView: UICollectionReusableView {
     lazy var titleLabel: UILabel = {
        let label = UILabel()
         label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"SFProRounded-Semibold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

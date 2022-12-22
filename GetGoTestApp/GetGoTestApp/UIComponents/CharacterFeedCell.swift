//
//  CharacterFeedCell.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//

import Foundation
import UIKit
class CharacterFeedCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 240
    @IBOutlet var itemViewBG: UIView!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemTitleLabel: UILabel! {
        didSet {
            itemTitleLabel.textColor = .black
           // itemTitleLabel.font = UIFont.defaultBoldFont(ofSize: 12.0)
        }
    }
    @IBOutlet var itemSubTitleLabel: UILabel! {
        didSet {
            itemSubTitleLabel.textColor = .black
           // itemTitleLabel.font = UIFont.defaultBoldFont(ofSize: 12.0)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // cancel image download
      //  itemImageView.cancelImageDownload()
        itemImageView.image = nil
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        itemViewBG.backgroundColor = .lightGray.withAlphaComponent(0.50)
        itemViewBG.layer.cornerRadius = 10
        itemImageView.layer.cornerRadius = itemViewBG.layer.cornerRadius
        itemImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        itemImageView.layer.masksToBounds = true
        itemImageView.clipsToBounds = true
    }
    func bind(_ item: CharacterResult?) {
        itemImageView.image = nil
        if let cellItem = item {
            itemImageView.loadImageUsingCache(withUrl: cellItem.image ?? "")
            itemTitleLabel.text = cellItem.name
            itemSubTitleLabel.text = cellItem.species
        }
    }
}

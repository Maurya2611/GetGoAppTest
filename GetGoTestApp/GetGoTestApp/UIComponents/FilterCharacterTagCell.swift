//
//  FilterCharacterTagCell.swift
//  GetGoTestApp
//
//  Created by Chandresh on 21/12/22.
//

import Foundation
import UIKit
class FilterCharacterTagCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 35
    @IBOutlet var titleLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        // cancel image download
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.sizeToFit()
    }
    func bind(_ item: String) {
        titleLabel.text = item
        titleLabel?.numberOfLines = 0
        //Cell Corner Radius
        titleLabel.layer.borderColor = UIColor.lightGray.cgColor
        titleLabel.textColor = UIColor(red: 0.746, green: 0.746, blue: 0.746, alpha: 1)
        titleLabel.layer.borderWidth = 2
        titleLabel.layer.cornerRadius = 8
    }
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                titleLabel.layer.borderColor = UIColor.tintColor.cgColor
                titleLabel.textColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            case false:
                titleLabel.layer.borderColor = UIColor.lightGray.cgColor
                titleLabel.textColor = UIColor(red: 0.746, green: 0.746, blue: 0.746, alpha: 1)
            }
        }
    }
}

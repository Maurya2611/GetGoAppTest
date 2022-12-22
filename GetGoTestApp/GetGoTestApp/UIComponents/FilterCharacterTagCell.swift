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
    }
    func bind(_ item: String) {
        titleLabel.text = item
    }
}

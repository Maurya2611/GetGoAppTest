//
//  LocationFeedCell.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//

import Foundation
import UIKit
class LocationFeedCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 80
    @IBOutlet var itemViewBG: UIView!
    @IBOutlet var itemTitleLabel: UILabel!
    @IBOutlet var itemSubTitleLabel: UILabel!
    @IBOutlet var itemDescription: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        // cancel image download
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        itemViewBG.backgroundColor = .systemGray3.withAlphaComponent(0.50)
        itemViewBG.dropShadow(color: .lightGray, radius: 10)

    }
    func bind(_ item: LocationDataResult?) {
        if let cellItem = item {
            itemTitleLabel.text = cellItem.name
            itemSubTitleLabel.text = cellItem.type
            itemDescription.text = "Dimension: \n\(cellItem.dimension ?? "")"
        }
    }
}

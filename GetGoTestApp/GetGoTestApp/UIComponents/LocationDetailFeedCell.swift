//
//  LocationDetailFeedCell.swift
//  GetGoTestApp
//
//  Created by Chandresh on 20/12/22.
//

import Foundation
import UIKit
class LocationDetailFeedCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 220
    @IBOutlet var itemTittleLabel: UILabel!
    @IBOutlet var itemCreatedLabel: UILabel!
    @IBOutlet var itemTypeLabel: UILabel!
    @IBOutlet var itemDimentionLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        // cancel image download
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func bind(_ item: LocationDataResult?) {
        itemTittleLabel.text = item?.name ?? ""
        itemTypeLabel.text = "Type: \(item?.type ?? "")"
        itemDimentionLabel.text = "Dimension: \(item?.dimension ?? "")"
        let font = UIFont(name:"SFProRounded-Regular",size: 12) ?? UIFont.boldSystemFont(ofSize: 14)
        let date = CommonUtils.getFromatedDateStringfromDate(given: item?.created ?? "") ?? Date()
        let formatedDate = CommonUtils.getFormattedDate(date: date, format: "HH:mm, MMMM-YYYY")
        itemCreatedLabel.attributedText = CommonUtils.attributedText(withString: "\n\(formatedDate)",
                                                         boldString: "Created:", font: font)
    }
}

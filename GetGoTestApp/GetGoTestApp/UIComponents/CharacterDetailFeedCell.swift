//
//  CharacterDetailFeedCell.swift
//  GetGoTestApp
//
//  Created by Chandresh on 20/12/22.
//

import Foundation
import UIKit
class CharacterDetailFeedCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 438
    @IBOutlet var itemViewBG: UIView!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemTitleLabel: UILabel!
    @IBOutlet var itemStatusLabel: UILabel!
    @IBOutlet var itemGenderLabel: UILabel!
    @IBOutlet var itemSpeciesLabel: UILabel!
    @IBOutlet var itemCreatedLabel: UILabel!
    @IBOutlet var itemTitleHeader1: UILabel!
    @IBOutlet var itemTitleHeader2: UILabel!
    @IBOutlet var itemSubTitleLabel1: UILabel!
    @IBOutlet var itemSubTitleLabel2: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        // cancel image download
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImageView.layer.cornerRadius = 10
        itemImageView.layer.masksToBounds = true
        itemImageView.clipsToBounds = true
    }
    func bind(_ item: CharacterResult?) {
        itemImageView.image = nil
        if let cellItem = item {
            itemImageView.loadImageUsingCache(withUrl: cellItem.image ?? "")
            itemTitleLabel.text = cellItem.name ?? ""
            if let status = cellItem.status {
                var imageName = ""
                switch status {
                case "Alive":
                    imageName = "icon_alive"
                case "Dead":
                    imageName = "icon_thriller"
                default:
                    imageName = "icon_unknown"
                }
                itemStatusLabel.attributedText = CommonUtils.attributedTextWithImage(with: "Status: \(cellItem.status ?? "") ", with: imageName)
            }
            if let status = cellItem.gender {
                var imageName = ""
                switch status {
                case "Female":
                    imageName = "icon_female"
                case "Male":
                    imageName = "icon_male"
                case "Neutral":
                    imageName = "icon_neutral"
                default:
                    imageName = "icon_unknown"
                }
                itemGenderLabel.attributedText = CommonUtils.attributedTextWithImage(with: "Gender: \(cellItem.gender ?? "") ", with: imageName)
            }
            itemSpeciesLabel.text = "Species: \(cellItem.species ?? "")"
            let font = UIFont(name:"SFProRounded-Regular",size: 12) ?? UIFont.boldSystemFont(ofSize: 14)
            let date = CommonUtils.getFromatedDateStringfromDate(given: cellItem.created ?? "") ?? Date()
            let formatedDate = CommonUtils.getFormattedDate(date: date, format: "HH:mm, MMMM-YYYY")
            itemCreatedLabel.attributedText = CommonUtils.attributedText(withString: "\n\(formatedDate)",
                                                             boldString: "Created:", font: font)
            itemSubTitleLabel1.text = cellItem.origin?.name
            itemSubTitleLabel2.text = cellItem.location?.name
        }
    }
}

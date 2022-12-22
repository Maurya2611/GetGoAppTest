//
//  EpisodeDetailFeedCell.swift
//  GetGoTestApp
//
//  Created by Chandresh on 20/12/22.
//

import Foundation
import UIKit
class EpisodeDetailFeedCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 220
    @IBOutlet var itemTittleLabel: UILabel!
    @IBOutlet var itemCreatedLabel: UILabel!
    @IBOutlet var itemAirDateLabel: UILabel!
    @IBOutlet var itemSeasonLabel: UILabel!
    @IBOutlet var itemEpisodeLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        // cancel image download
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func bind(_ item: EpisodesDataResult?) {
        itemTittleLabel.text = item?.name ?? ""
        let font = UIFont(name:"SFProRounded-Regular", size: 12) ?? UIFont.boldSystemFont(ofSize: 14)
        let date = CommonUtils.getFromatedDateStringfromDate(given: item?.created ?? "") ?? Date()
        let formatedDate = CommonUtils.getFormattedDate(date: date, format: "HH:mm, MMMM-YYYY")
        itemCreatedLabel.attributedText = CommonUtils.attributedText(withString: "\n\(formatedDate)",
                                                         boldString: "Created:", font: font)
        itemAirDateLabel.text = "AirDate: \(item?.airDate ?? "")"
        if let seasonText = item?.episode {
            let font = UIFont(name:"SFProRounded-Regular", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
            let text = String(seasonText[..<seasonText.index(seasonText.startIndex, offsetBy: 3)])
            itemSeasonLabel.attributedText =  CommonUtils.attributedText(withString: String(text.suffix(2)),
                                                             boldString: "Season: ", font: font)
            itemEpisodeLabel.attributedText = CommonUtils.attributedText(withString: String(seasonText.suffix(2)),
                                                               boldString: "Episode: ", font: font)
        }
    }
}

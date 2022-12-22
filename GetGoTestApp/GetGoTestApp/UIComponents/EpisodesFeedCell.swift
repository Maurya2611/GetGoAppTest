//
//  EpisodesFeedCell.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//

import Foundation
import UIKit
class EpisodesFeedCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 116
    @IBOutlet var itemViewBG: UIView!
    @IBOutlet var itemTitleLabel: UILabel!
    @IBOutlet var itemSeasonLabel: UILabel!
    @IBOutlet var itemEpisodeLabel: UILabel!
    @IBOutlet var itemDescriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // cancel image download
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        itemViewBG.backgroundColor = .systemGray3.withAlphaComponent(0.50)
        itemViewBG.dropShadow(color: .lightGray, radius: 10)
    }
    func bind(_ item: EpisodesDataResult?) {
        if let cellItem = item {
            itemTitleLabel.text = cellItem.name
            if let seasonText = cellItem.episode {
                let text = String(seasonText[..<seasonText.index(seasonText.startIndex, offsetBy: 3)])
                itemSeasonLabel.text = "season: \(text.suffix(2))"
                itemEpisodeLabel.text = "episode: \(seasonText.suffix(2))"
                //                for (index, character) in seasonText.enumerated() {
                //                    if character.isNumber {
                //                        let startIndex = seasonText.index(seasonText.startIndex, offsetBy: index)
                //                        let endIndex = seasonText.index(seasonText.startIndex, offsetBy: index + 1)
                //                        let range = startIndex..<endIndex
                //                        let digits = seasonText[range]
                //                        if let number = Int(digits) {
                //                            if number > 9 {
                // print in two digits
                //                                print(digits)
                //                            } else {
                // print in single digits
                //                                print(number)
                //                            }
                //                        }
                //                    }
                //                }
            }
            
            itemDescriptionLabel.text = "AirDate:\n\(cellItem.airDate ?? "")"
        }
    }
}

//
//  CommonLinkFeedCell.swift
//  GetGoTestApp
//
//  Created by Chandresh on 20/12/22.
//

import Foundation
import UIKit
class CommonLinkFeedCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 24
    @IBOutlet var itemLinkLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        // cancel image download
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func bind(_ item: String) {
        itemLinkLabel.text = item
    }
}

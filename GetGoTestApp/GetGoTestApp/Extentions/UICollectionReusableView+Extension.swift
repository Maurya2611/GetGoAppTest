//
//  UICollectionReusableView+Extension.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//

import Foundation
import UIKit
internal extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
}

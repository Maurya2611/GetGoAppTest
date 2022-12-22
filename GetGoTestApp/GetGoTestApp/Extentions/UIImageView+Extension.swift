//
//  UIImageView+Extension.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//
import Foundation
import UIKit
let imageCache = NSCache<NSString, AnyObject>()
extension UIImageView {
    func addBorder() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red: 222/255.0, green: 225/255.0, blue: 227/255.0, alpha: 1.0).cgColor
    }
    fileprivate var activityIndicator: UIActivityIndicatorView {
    get {
        if let indicator = self.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
            return indicator
        }

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tintColor = .black
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)

        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)

        self.addConstraints([centerX, centerY])
        return activityIndicator
      }
    }
    func loadImageUsingCache(withUrl urlString: String) {
        if let url = URL(string: urlString) {
            // check cached image
            if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
                DispatchQueue.main.async {
                    self.image = cachedImage
                    self.contentMode = .scaleAspectFill
                }
                return
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
                // if not, download image from url
                URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.removeFromSuperview()
                        }
                        print("error...")
                    } else {
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.removeFromSuperview()
                            if let imageData = data, let image = UIImage(data: imageData) {
                                imageCache.setObject(image, forKey: urlString as NSString)
                                self.image = image
                                self.contentMode = .scaleAspectFill
                            } else {
                                self.image = #imageLiteral(resourceName: "iconNoImage")
                                self.contentMode = .scaleAspectFill
                            }
                        }
                    }
                }).resume()
            }
        }
    }
}

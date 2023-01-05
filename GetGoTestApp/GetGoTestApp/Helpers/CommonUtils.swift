//
//  CommonUtils.swift
//  GetGoTestApp
//
//  Created by Chandresh on 16/12/22.
//

import Foundation
import UIKit

struct CommonUtils {
    //  MARK: Initialize Loader
    static var indicator: MaterialLoadingIndicator = {
        let indicator = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        indicator.indicatorColor = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.green.cgColor]
        indicator.startAnimating()
        indicator.isHidden = true
        return indicator
    }()
    //  MARK: Show Loader
    static func showOnLoader(in view: UIView) {
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.isHidden = false
        DispatchQueue.main.async {
            indicator.startAnimating()
        }
    }
    //  MARK: Hide Loader
    static func hideOffLoader() {
        DispatchQueue.main.async {
            indicator.stopAnimating()
            indicator.isHidden = true
            indicator.removeFromSuperview()
        }
    }
    //  MARK: Show Alert
    static func showAlert(in view: UIViewController?, withTitle: String?, withBodyMessage: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: withTitle, message: withBodyMessage,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            view?.present(alert, animated: true)
        }
    }
    //  MARK: Condition to check load more data
    static  func shouldLoadMoreData(totalPage: Int, totalPageLoaded: Int) -> Bool {
        return totalPage >= totalPageLoaded
    }
    //  MARK: NSAttributedString
    static func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: boldString,
                                                         attributes: [NSAttributedString.Key.font: UIFont(name:"SFProRounded-Semibold",size: 16)
                                                                      ?? UIFont.boldSystemFont(ofSize: 14)])
        let normalString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        attributedString.append(normalString)
        return attributedString
    }
    //  MARK: NSAttributedString with image
    static func attributedTextWithImage(with string: String, with imageName: String ) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: imageName)
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 28, height: 28)
        let attributedTextWithImage = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: string)
        completeText.append(attributedTextWithImage)
        return completeText
        
    }
    //  MARK: FormattedDate with given format
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    static func getFromatedDateStringfromDate(given str: String)-> Date? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date: Date? = dateFormatterGet.date(from: str)
        return date ?? Date()
    }
    static func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    static func uniqueElementsFrom<T: Hashable>(array: [T]) -> [T] {
        var set = Set<T>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
}


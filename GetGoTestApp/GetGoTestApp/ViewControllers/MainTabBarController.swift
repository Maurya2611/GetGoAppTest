//
//  MainTabBarController.swift
//  GetGoTestApp
//
//  Created by Chandresh on 18/12/22.
//  Copyright © 2022 Chandresh. All rights reserved.
//


import UIKit

// MARK: - MainTabBarController
class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.tabBar.layer.addSublayer(bottomLine)
        // Do any additional setup after loading the view.
    }
}


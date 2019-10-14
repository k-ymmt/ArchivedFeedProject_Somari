//
//  MainTabRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

protocol MainTabRoutable {
}

class MainTabRouter: MainTabRoutable {
    static func assembleModules(
        feedsViewController: UIViewController,
        additionalFeedViewController: UIViewController
    ) -> UIViewController {
        let tabViewController = MainTabViewController()
        
        let font = UIFont.systemFont(ofSize: 18, weight: .bold)
        feedsViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(symbol: .list, withConfiguration: .init(font: font)),
            selectedImage: nil
        )

        additionalFeedViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(symbol: .plusSquare, withConfiguration: .init(font: font)),
            selectedImage: UIImage(symbol: .plusSquare, withConfiguration: .init(font: font))
        )
        
        tabViewController.setViewControllers([
            UINavigationController(rootViewController: feedsViewController),
            UINavigationController(rootViewController: additionalFeedViewController)
        ], animated: false)
        
        let router = MainTabRouter(tabController: tabViewController)
        return tabViewController
    }
    
    private weak var tabController: MainTabViewController?
    
    
    init(tabController: MainTabViewController) {
        self.tabController = tabController
    }
}

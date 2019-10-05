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

struct MainTabRouter: MainTabRoutable {
    static func assembleModules() -> UIViewController {
        let tabViewController = MainTabViewController()
        let router = MainTabRouter(tabController: tabViewController)
        return tabViewController
    }
    
    private weak var tabController: MainTabViewController?
    init(tabController: MainTabViewController) {
        self.tabController = tabController
        let font = UIFont.systemFont(ofSize: 18, weight: .bold)
        let feedsViewController = FeedsRouter.assembleModules()
        feedsViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(symbol: .list, withConfiguration: .init(font: font)),
            selectedImage: nil
        )
        let additionalFeedViewController = AdditionalFeedRouter.assembleModules()
        additionalFeedViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(symbol: .search, withConfiguration: .init(font: font)),
            selectedImage: UIImage(symbol: .search, withConfiguration: .init(font: font))
        )
        
        self.tabController?.setViewControllers([feedsViewController, additionalFeedViewController], animated: false)
    }
    
    func navigateFeeds() {
        self.tabController?.selectedIndex = 0
    }
}

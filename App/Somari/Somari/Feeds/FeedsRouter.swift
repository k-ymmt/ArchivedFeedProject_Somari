//
//  FeedsRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

protocol FeedsRoutable {
    func navigateAdditionalFeedView()
    func showSafariViewController(url: URL)
}

class FeedsRouter: FeedsRoutable {
    private weak var viewController: UIViewController!

    static func assembleModules() -> UIViewController {
        let router = FeedsRouter()
        let feedsService = FeedKitService()
        let interactor = FeedsInteractor(feedService: feedsService)
        let presenter = FeedsPresenter(router: router, interactor: interactor)
        let viewController = FeedsViewController(presenter: presenter)
        router.viewController = viewController
        
        return UINavigationController(rootViewController: router.viewController)
    }
    
    func navigateAdditionalFeedView() {
        let vc = AdditionalFeedRouter.assembleModules()
        viewController.present(vc, animated: true)
    }
    
    func showSafariViewController(url: URL) {
        let sfvc = SFSafariViewController(url: url)
        viewController.present(sfvc, animated: true)
    }
}

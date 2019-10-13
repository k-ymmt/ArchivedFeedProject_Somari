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
import SomariFoundation

protocol FeedsRoutable {
    func showSafariViewController(url: URL)
}

class FeedsRouter: FeedsRoutable & EmptyOutputRouter {
    struct Dependency {
        let feedService: FeedService
        let storageService: StorageService
    }
    
    private weak var viewController: UIViewController!
    
    static func assembleModules(dependency: FeedsRouter.Dependency) -> UIViewController {
        let router = FeedsRouter()
        let interactor = FeedsInteractor(feedService: dependency.feedService, storageService: dependency.storageService)
        let presenter = FeedsPresenter(router: router, interactor: interactor)
        let viewController = FeedsViewController(presenter: presenter)
        router.viewController = viewController
        
        return viewController
    }

    func showSafariViewController(url: URL) {
        let sfvc = SFSafariViewController(url: url)
        viewController.present(sfvc, animated: true)
    }
}

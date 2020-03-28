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
    func gotoAdditionView()
}

class FeedsRouter: FeedsRoutable & Router {
    struct Dependency {
        let feedService: FeedService
        let storageService: StorageService
        let loginService: LoginService
        let feedItemCacheService: FeedItemCacheService
    }

    static func assembleModules(dependency: FeedsRouter.Dependency, action: @escaping (FeedsNavigateAction) -> Void) -> UIViewController {
        let router = FeedsRouter(action: action)
        let interactor = FeedsInteractor(
            feedService: dependency.feedService,
            storageService: dependency.storageService,
            loginService: dependency.loginService,
            feedItemCacheService: dependency.feedItemCacheService
        )
        let presenter = FeedsPresenter(router: router, interactor: interactor)
        let viewController = FeedsViewController(presenter: presenter)
        router.viewController = viewController

        return viewController
    }
    
    private weak var viewController: UIViewController!
    private let navigateAction: (FeedsNavigateAction) -> Void
    
    private init(action: @escaping (FeedsNavigateAction) -> Void) {
        self.navigateAction = action
    }
    
    func gotoAdditionView() {
        navigateAction(.gotoAdditionView)
    }

    func showSafariViewController(url: URL) {
        let sfvc = SFSafariViewController(url: url)
        viewController.present(sfvc, animated: true)
    }
}

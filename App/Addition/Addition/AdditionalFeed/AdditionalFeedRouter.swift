//
//  AdditionalFeedRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import SomariFoundation

protocol AdditionalFeedRoutable {
    func navigateToAdditionalFeedConfirm(url: URL, title: String?, items: [FeedItem])
}

class AdditionalFeedRouter: AdditionalFeedRoutable & Router {
    struct Dependency {
        let feedService: FeedService
        let accountService: AccountService
        let storageService: StorageService
    }

    enum Output {
        case additionFeedSuccess
    }

    private weak var viewController: UIViewController!

    static func assembleModules(
        dependency: AdditionalFeedRouter.Dependency,
        action: @escaping (AdditionalFeedRouter.Output) -> Void
    ) -> UIViewController {
        let router = AdditionalFeedRouter(dependency: dependency, action: action)
        let interactor = AdditionalFeedInteractor(
            feedService: dependency.feedService,
            accountService: dependency.accountService,
            storageService: dependency.storageService
        )
        let presenter = AdditionalFeedPresenter(router: router, interactor: interactor)
        let viewController = AdditionalFeedViewController(presenter: presenter)
        router.viewController = viewController

        return viewController
    }

    private let action: (AdditionalFeedRouter.Output) -> Void
    private let dependency: Dependency

    private init(dependency: Dependency, action: @escaping (AdditionalFeedRouter.Output) -> Void) {
        self.dependency = dependency
        self.action = action
    }

    func navigateToAdditionalFeedConfirm(url: URL, title: String?, items: [FeedItem]) {
        DispatchQueue.main.async {
            let viewController = AdditionalFeedConfirmRouter.assembleModules(dependency: .init(
                url: url,
                title: title,
                items: items,
                storageService: self.dependency.storageService,
                accountService: self.dependency.accountService
            )) { [weak self] (_) in
                self?.action(.additionFeedSuccess)
            }
            self.viewController.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

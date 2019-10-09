//
//  AdditionalFeedRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

protocol AdditionalFeedRoutable {
    func dismiss()
    func navigateToAdditionalFeedConfirm(url: URL, items: [FeedItem])
}

class AdditionalFeedRouter: AdditionalFeedRoutable {
    private weak var viewController: UIViewController!
    static func assembleModules() -> UIViewController {
        let router = AdditionalFeedRouter()
        let interactor = AdditionalFeedInteractor(feedService: FeedKitService())
        let presenter = AdditionalFeedPresenter(router: router, interactor: interactor)
        let viewController = AdditionalFeedViewController(presenter: presenter)
        router.viewController = viewController
        
        return router.viewController
    }
    
    func dismiss() {
        viewController.presentingViewController?.dismiss(animated: true)
    }
    
    func navigateToAdditionalFeedConfirm(url: URL, items: [FeedItem]) {
        DispatchQueue.main.async {
            let viewController = AdditionalFeedConfirmRouter.assembleModules(url: url, feedItems: items)
            self.viewController.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

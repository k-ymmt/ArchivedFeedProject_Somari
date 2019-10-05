//
//  AdditionalFeedConfirmRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/30.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

protocol AdditionalFeedConfirmRoutable {
    func showSafariViewController(url: URL)
}

class AdditionalFeedConfirmRouter: AdditionalFeedConfirmRoutable {
    private weak var viewController: AdditionalFeedConfirmViewController!

    static func assembleModules(feedItems: [FeedItem]) -> AdditionalFeedConfirmViewController {
        let router = AdditionalFeedConfirmRouter()
        let interactor = AdditionalFeedConfirmInteractor(feedService: FeedKitService())
        let presenter = AdditionalFeedConfirmPresenter(router: router, interactor: interactor)
        let viewController = AdditionalFeedConfirmViewController(feedItems: feedItems, presenter: presenter)
        router.viewController = viewController
        
        return viewController
    }
    
    func showSafariViewController(url: URL) {
        let sfvc = SFSafariViewController(url: url)
        viewController.present(sfvc, animated: true)
    }
}

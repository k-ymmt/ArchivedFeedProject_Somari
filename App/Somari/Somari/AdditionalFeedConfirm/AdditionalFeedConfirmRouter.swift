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
    func popToRoot()
    func showSafariViewController(url: URL)
}

class AdditionalFeedConfirmRouter: AdditionalFeedConfirmRoutable {
    private weak var viewController: AdditionalFeedConfirmViewController!

    static func assembleModules(url: URL, feedItems: [FeedItem]) -> AdditionalFeedConfirmViewController {
        let router = AdditionalFeedConfirmRouter()
        let interactor = AdditionalFeedConfirmInteractor(storageService: FirebaseStorageService())
        let presenter = AdditionalFeedConfirmPresenter(url: url, feedItems: feedItems, router: router, interactor: interactor)
        let viewController = AdditionalFeedConfirmViewController(presenter: presenter)
        router.viewController = viewController
        
        return viewController
    }
    
    func showSafariViewController(url: URL) {
        let sfvc = SFSafariViewController(url: url)
        viewController.present(sfvc, animated: true)
    }
    
    func popToRoot() {
        viewController.navigationController?.popViewController(animated: true)
    }
}

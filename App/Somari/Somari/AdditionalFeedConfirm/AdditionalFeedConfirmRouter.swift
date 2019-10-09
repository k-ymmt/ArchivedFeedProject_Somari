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

    static func assembleModules(url: URL, title: String?, items: [FeedItem]) -> AdditionalFeedConfirmViewController {
        let router = AdditionalFeedConfirmRouter()
        let storageService = FirebaseStorageService()
        let loginService = FirebaseLoginService()
        let interactor = AdditionalFeedConfirmInteractor(storageService: storageService, loginService: loginService)
        let info = AdditionalFeedConfirmPresenter.FeedInfo(url: url, title: title, items: items)
        let presenter = AdditionalFeedConfirmPresenter(info: info, router: router, interactor: interactor)
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

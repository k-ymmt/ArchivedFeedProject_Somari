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
import SomariFoundation

protocol AdditionalFeedConfirmRoutable {
    func additionSuccess()
    func showSafariViewController(url: URL)
}

class AdditionalFeedConfirmRouter: AdditionalFeedConfirmRoutable & Router {
    struct Dependency {
        let url: URL
        let title: String?
        let items: [FeedItem]
        let storageService: StorageService
        let loginService: LoginService
    }
    
    enum Output {
        case feedAdditionSuccess
    }
    
    static func assembleModules(dependency: AdditionalFeedConfirmRouter.Dependency, action: @escaping (AdditionalFeedConfirmRouter.Output) -> Void) -> UIViewController {
        let router = AdditionalFeedConfirmRouter(action: action)
        let interactor = AdditionalFeedConfirmInteractor(storageService: dependency.storageService, loginService: dependency.loginService)
        let info = AdditionalFeedConfirmPresenter.FeedInfo(url: dependency.url, title: dependency.title, items: dependency.items)
        let presenter = AdditionalFeedConfirmPresenter(info: info, router: router, interactor: interactor)
        let viewController = AdditionalFeedConfirmViewController(presenter: presenter)
        router.viewController = viewController
        
        return viewController
    }
    
    private weak var viewController: AdditionalFeedConfirmViewController!
    private let action: (AdditionalFeedConfirmRouter.Output) -> Void
    
    private init(action: @escaping (AdditionalFeedConfirmRouter.Output) -> Void) {
        self.action = action
    }
    
    func showSafariViewController(url: URL) {
        let sfvc = SFSafariViewController(url: url)
        viewController.present(sfvc, animated: true)
    }
    
    func additionSuccess() {
        action(.feedAdditionSuccess)
        viewController.navigationController?.popToRootViewController(animated: true)
    }
}

//
//  LoginRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation
import UIKit

protocol LoginRoutable {
    func navigateToLoginSuccessPage()
}

class LoginRouter: LoginRoutable & Router {
    struct Dependency {
        let accountService: AccountService
    }

    static func assembleModules(dependency: Dependency, action: @escaping (AccountNavigationAction) -> Void) -> UIViewController {
        let router = LoginRouter(navigationAction: action)
        let interactor = LoginInteractor(accountService: dependency.accountService)
        let presenter = LoginPresenter(interactor: interactor, router: router)
        let viewController = LoginViewController(presenter: presenter)

        return viewController
    }

    private let navigationAction: (AccountNavigationAction) -> Void

    private init(navigationAction: @escaping (AccountNavigationAction) -> Void) {
        self.navigationAction = navigationAction
    }

    func navigateToLoginSuccessPage() {
        navigationAction(.loginSuccess)
    }
}

//
//  LoginRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol LoginRoutable {
    func navigateToMainTab()
}

class LoginRouter: LoginRoutable {
    static func assembleModules() -> LoginViewController {
        let router = LoginRouter()
        let interactor = LoginInteractor(loginService: FirebaseLoginService())
        let presenter = LoginPresenter(interactor: interactor, router: router)
        let viewController = LoginViewController(presenter: presenter)
        router.viewController = viewController
        
        return router.viewController
    }
    
    private weak var viewController: LoginViewController!
    
    func navigateToMainTab() {
        let tabController = MainTabRouter.assembleModules()
        viewController.navigationController?.setViewControllers([tabController], animated: true)
    }
}

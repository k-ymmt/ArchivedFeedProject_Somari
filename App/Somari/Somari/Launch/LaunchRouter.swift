//
//  LaunchRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/06.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import SomariCore

protocol LaunchRoutable {
    func showLoginPage()
    func navigateToMain()
}

class LaunchRouter: LaunchRoutable {
    static func assembleModules() -> UINavigationController {
        let router = LaunchRouter()
        let interactor = LaunchInteractor(loginService: FirebaseLoginService())
        let presenter = LaunchPresenter(interactor: interactor, router: router)
        let viewController = LaunchViewController(presenter: presenter)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        router.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
        return router.navigationController
    }
    
    private weak var navigationController: UINavigationController!
    
    func showLoginPage() {
        let viewController = LoginRouter.assembleModules()
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func navigateToMain() {
        let tabController = MainTabRouter.assembleModules()
        navigationController.setViewControllers([tabController], animated: true)
    }
}

//
//  LaunchRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/06.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import SomariFoundation

protocol LaunchRoutable {
}

class LaunchRouter: LaunchRoutable & Router {
    struct Dependency {
    }
    
    enum Navigation: NavigationAction {
    }
    
    static func assembleModules(dependency: LaunchRouter.Dependency, action: @escaping (LaunchRouter.Navigation) -> Void) -> UIViewController {
        let router = LaunchRouter()
        let interactor = LaunchInteractor()
        let presenter = LaunchPresenter(interactor: interactor, router: router)
        let viewController = LaunchViewController(presenter: presenter)

        return viewController
    }
}

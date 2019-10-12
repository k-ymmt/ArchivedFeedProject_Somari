//
//  GatewayProvider.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/13.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import SomariCore
import Login

class GatewayProvider {
    private let window: UIWindow
    
    let login: LoginGateway
    
    init(window: UIWindow, resolver: DependencyResolver) {
        self.login = LoginGateway(dependency: .init(
            loginService: resolver.loginService
        ))
        self.window = window
        subscribeOutputs()
    }
    
    func launch() {
        let viewController = LaunchRouter.assembleModules(dependency: .init(), action: { _ in })
        window.rootViewController = viewController
        self.login.input(.startLoginStateListening)
    }
    
    private func subscribeOutputs() {
        self.login.output { [weak self] (output) in self?.loginGatewayOutputAction(output: output) }
    }
}

// MARK: - LoginGateway
private extension GatewayProvider {
    private func loginGatewayOutputAction(output: LoginGateway.Output) {
        switch output {
        case .loginSuccess:
            break
        case .loginFailure(let error):
            switch error {
            case .notLogin:
                login.input(.showLoginPage)
            case .loginFailed(let error):
                login.input(.showLoginPage)
            case .unknown:
                break
            }
        case .showLoginPage(let viewController):
            break
        }
    }
}

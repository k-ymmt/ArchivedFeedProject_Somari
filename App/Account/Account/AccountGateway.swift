//
//  AccountGateway.swift
//  Account
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import SomariFoundation
import Combine

enum AccountNavigationAction {
    case loginSuccess
}

public class AccountGateway: Gateway {
    public struct Dependency {
        let accountService: AccountService

        public init(accountService: AccountService) {
            self.accountService = accountService
        }
    }

    public enum Input {
        case showLoginPage
        case startLoginStateListening
    }

    public enum Output {
        case loginSuccess
        case loginFailure(LoginError)
        case showLoginPage(UIViewController)
    }

    private var outputAction: ((Output) -> Void)?
    private let dependency: Dependency

    private var cancellables: Set<AnyCancellable> = Set()

    public required init(dependency: AccountGateway.Dependency) {
        self.dependency = dependency
    }

    public func input(_ value: AccountGateway.Input) {
        switch value {
        case .showLoginPage:
            outputAction?(.showLoginPage(makeLoginPage()))
        case .startLoginStateListening:
            self.dependency.accountService.listenLoginState()
            .sink { [weak self] result in self?.receiveLoginResult(result: result) }
            .store(in: &cancellables)
        }
    }

    public func output(_ action: @escaping (AccountGateway.Output) -> Void) {
        self.outputAction = action
    }

    private func receiveLoginResult(result: Result<User, LoginError>) {
        switch result {
        case .success:
            outputAction?(.loginSuccess)
        case .failure(let error):
            outputAction?(.loginFailure(error))
        }
    }

    private func makeLoginPage() -> UIViewController {
        let viewController = LoginRouter.assembleModules(dependency: .init(accountService: dependency.accountService)) { [weak self] (action) in
            switch action {
            case .loginSuccess:
                self?.outputAction?(.loginSuccess)
            }
        }

        return viewController
    }
}

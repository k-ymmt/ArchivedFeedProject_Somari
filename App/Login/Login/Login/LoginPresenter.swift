//
//  LoginPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation

protocol LoginPresentable {
    func loginAnonymously()
}

class LoginPresenter: LoginPresentable {
    private let interactor: LoginInteractable
    private let router: LoginRoutable

    init(interactor: LoginInteractor, router: LoginRoutable) {
        self.interactor = interactor
        self.router = router
    }

    func loginAnonymously() {
        interactor.loginAnonymosly { [weak self] (result) in
            switch result {
            case .success:
                self?.router.navigateToLoginSuccessPage()
            case .failure(let error):
                Logger.error(error)
            }
        }
    }
}

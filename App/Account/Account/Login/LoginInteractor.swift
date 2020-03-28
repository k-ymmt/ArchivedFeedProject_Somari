//
//  LoginInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation

protocol LoginInteractable {
    func loginAnonymosly(completion: @escaping (Result<User, LoginError>) -> Void)
}

class LoginInteractor: LoginInteractable {
    private let accountService: AccountService

    init(accountService: AccountService) {
        self.accountService = accountService
    }

    func loginAnonymosly(completion: @escaping (Result<User, LoginError>) -> Void) {
        accountService.loginAnonymously(completion: completion)
    }
}

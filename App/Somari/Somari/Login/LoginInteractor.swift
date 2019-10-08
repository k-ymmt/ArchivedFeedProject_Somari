//
//  LoginInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol LoginInteractable {
    func loginAnonymosly(completion: @escaping (Result<User, LoginError>) -> Void)
}

class LoginInteractor: LoginInteractable {
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func loginAnonymosly(completion: @escaping (Result<User, LoginError>) -> Void) {
        loginService.loginAnonymously(completion: completion)
    }
}

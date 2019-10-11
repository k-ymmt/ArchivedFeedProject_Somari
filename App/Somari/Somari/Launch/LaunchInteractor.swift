//
//  LaunchInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/06.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine
import SomariKit

protocol LaunchInteractable {
    func tryLogin() -> AnyPublisher<Bool, LoginError>
}

class LaunchInteractor: LaunchInteractable {
    let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func tryLogin() -> AnyPublisher<Bool, LoginError> {
        loginService.listenLoginState()
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
}

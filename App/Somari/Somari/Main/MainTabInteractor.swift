//
//  MainTabInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/06.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine
import SomariFoundation

protocol MainTabInteractable {
}

class MainTabInteractor: MainTabInteractable {
    private let loginService: LoginService

    init(loginService: LoginService) {
        self.loginService = loginService
    }
}

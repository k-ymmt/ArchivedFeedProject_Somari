//
//  DependencyResolver.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/13.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariCore
import SomariFoundation

class DependencyResolver {
    let loginService: LoginService
    init() {
        self.loginService = FirebaseLoginService()
    }
}

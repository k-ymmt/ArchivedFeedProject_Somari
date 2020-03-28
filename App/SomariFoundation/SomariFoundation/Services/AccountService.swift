//
//  AccountService.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

public protocol User {
}

public enum LoginError: Error {
    case notLogin
    case loginFailed(Error)
    case unknown
}

public protocol AccountService {
    func uid() -> String?
    func loginAnonymously(completion: @escaping (Result<User, LoginError>) -> Void)
    func listenLoginState() -> AnyPublisher<Result<User, LoginError>, Never>
}

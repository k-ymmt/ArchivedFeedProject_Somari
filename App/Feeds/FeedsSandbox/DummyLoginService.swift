//
//  DummyLoginService.swift
//  FeedsSandbox
//
//  Created by Kazuki Yamamoto on 2019/10/14.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation
import Combine

struct DummyUser: User {
}

class DummyLoginService: LoginService {
    func uid() -> String? {
        return "1"
    }
    
    func loginAnonymously(completion: @escaping (Result<User, LoginError>) -> Void) {
        completion(.success(DummyUser()))
    }
    
    func listenLoginState() -> AnyPublisher<Result<User, LoginError>, Never> {
        let subject = PassthroughSubject<Result<User, LoginError>, Never>()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            subject.send(.success(DummyUser()))
        }
        
        return subject.eraseToAnyPublisher()
    }
}

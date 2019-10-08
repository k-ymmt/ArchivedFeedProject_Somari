//
//  LoginService.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine

protocol User {
}

enum LoginError: Error {
    case loginFailed(Error)
    case unknown
}

protocol LoginService {
    func loginAnonymously(completion: @escaping (Result<User, LoginError>) -> Void)
    func listenLoginState() -> AnyPublisher<User?, LoginError>
}

private struct FirebaseUser: User {
    private let user: FirebaseAuth.User
    
    init(user: FirebaseAuth.User) {
        self.user = user
    }
}

extension LoginError {
    init?(with firebaseError: NSError) {
        guard let code = AuthErrorCode(rawValue: firebaseError.code) else {
            return nil
        }
        
        switch code {
        default:
            self = .unknown
        }
    }
}

class FirebaseLoginService: LoginService {
    private let keychainService: KeychainService
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    func loginAnonymously(completion: @escaping (Result<User, LoginError>) -> Void) {
        Auth.auth().signInAnonymously { (user, error) in
            if let error = error {
                guard let loginError = LoginError(with: error as NSError) else {
                    completion(.failure(.unknown))
                    return
                }
                
                completion(.failure(loginError))
                return
            }
            guard let user = user else {
                completion(.failure(.unknown))
                return
            }
            
            completion(.success(FirebaseUser(user: user.user)))
        }
    }
    
    func listenLoginState() -> AnyPublisher<User?, LoginError> {
        let subject = PassthroughSubject<User?, LoginError>()
        
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {
                logger.debug("User not login")
                subject.send(nil)
                return
            }
            logger.debug("User login")
            subject.send(FirebaseUser(user: user))
        }
        
        _ = subject.handleEvents(receiveCancel: { Auth.auth().removeStateDidChangeListener(handle) })
        
        return subject.eraseToAnyPublisher()
    }
}

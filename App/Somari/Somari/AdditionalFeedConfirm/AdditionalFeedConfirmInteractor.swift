//
//  AdditionalFeedConfirmInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/30.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation

protocol AdditionalFeedConfirmInteractable {
    func saveFeedInfo(info: UserSettingsFeedData, completion: @escaping (Result<Void, Error>) -> Void)
}

class AdditionalFeedConfirmInteractor: AdditionalFeedConfirmInteractable {
    private let storageService: StorageService
    private let loginService: LoginService

    init(storageService: StorageService, loginService: LoginService) {
        self.storageService = storageService
        self.loginService = loginService
    }
    
    func saveFeedInfo(info: UserSettingsFeedData, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = loginService.uid() else {
            completion(.failure(LoginError.notLogin))
            return
        }
        storageService.add(key: UserSettingsFeedData.key(uid: uid), info) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

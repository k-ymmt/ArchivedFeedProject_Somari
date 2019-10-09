//
//  FeedsInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol FeedsInteractable {
    func getFeed(url: URL, completion: @escaping (Result<Feed, FeedError>) -> Void) -> Cancellable
    func getUserSettings(completion: @escaping (Result<[UserSettingsFeedData], Error>) -> Void)
}

class FeedsInteractor: FeedsInteractable {
    private let feedService: FeedService
    private let storageService: StorageService
    private let loginService: LoginService

    init(feedService: FeedService, storageService: StorageService, loginService: LoginService) {
        self.feedService = feedService
        self.storageService = storageService
        self.loginService = loginService
    }
    
    func getUserSettings(completion: @escaping (Result<[UserSettingsFeedData], Error>) -> Void) {
        guard let uid = loginService.uid() else {
            completion(.failure(LoginError.notLogin))
            return
        }
        return storageService.get(key: UserSettingsFeedData.key(uid: uid), completion: completion)
    }
    
    func getFeed(url: URL, completion: @escaping (Result<Feed, FeedError>) -> Void) -> Cancellable {
        return feedService.getFeed(url: url, completion: completion)
    }
}

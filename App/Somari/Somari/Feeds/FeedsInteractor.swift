//
//  FeedsInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

private let userSettingsKey = "feedInfo"

protocol FeedsInteractable {
    func getFeed(url: URL, completion: @escaping (Result<Feed, FeedError>) -> Void) -> Cancellable
    func getUserSettings(completion: @escaping (Result<[FeedInfo], Error>) -> Void)
}

class FeedsInteractor: FeedsInteractable {
    private let feedService: FeedService
    private let storageService: StorageService

    init(feedService: FeedService, storageService: StorageService) {
        self.feedService = feedService
        self.storageService = storageService
    }
    
    func getUserSettings(completion: @escaping (Result<[FeedInfo], Error>) -> Void) {
        return storageService.get(key: userSettingsKey, completion: completion)
    }
    
    func getFeed(url: URL, completion: @escaping (Result<Feed, FeedError>) -> Void) -> Cancellable {
        return feedService.getFeed(url: url, completion: completion)
    }
}

//
//  FeedsInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation

protocol FeedsInteractable {
    func getFeed(url: URL, completion: @escaping (Result<Feed, FeedError>) -> Void) -> Cancellable
    func getFeeds(urls: [URL], completion: @escaping (Result<[FeedItem], FeedError>) -> Void) -> Cancellable
    func getUserSettings(completion: @escaping (Result<[UserSettingsFeedData], Error>) -> Void)
}

class FeedsInteractor: FeedsInteractable {
    private let feedService: FeedService
    private let storageService: StorageService
    private let loginService: LoginService
    
    private var buffer: [FeedItem] = []

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
    
    func getFeeds(urls: [URL], completion: @escaping (Result<[FeedItem], FeedError>) -> Void) -> Cancellable {
        return feedService.getFeeds(urls: urls) { [weak self] result in
            guard let self = self else {
                return
            }
            var items: [FeedItem] = []
            switch result {
            case .success(let feeds):
                let feedItems = feeds.flatMap { $0.feedItems() }
                for item in feedItems {
                    if let id = item.id, self.buffer.contains(where: { $0.id == id }) {
                        continue
                    }
                    
                    items.append(item)
                }
                self.buffer.append(contentsOf: items)
                completion(.success(items.sorted(by: { compareDate($0.date, $1.date) })))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private func compareDate(_ l: Date?, _ r: Date?) -> Bool {
    guard l != r else {
        return true
    }
    guard let l = l else {
        return true
    }
    guard let r = r else {
        return false
    }
    return l < r
}


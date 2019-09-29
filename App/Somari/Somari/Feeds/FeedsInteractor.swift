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
}

class FeedsInteractor: FeedsInteractable {
    private let feedService: FeedService

    init(feedService: FeedService) {
        self.feedService = feedService
    }
    
    func getFeed(url: URL, completion: @escaping (Result<Feed, FeedError>) -> Void) -> Cancellable {
        return feedService.getFeed(url: url, completion: completion)
    }
}

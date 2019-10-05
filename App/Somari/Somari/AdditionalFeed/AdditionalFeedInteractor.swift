//
//  AdditionalFeedInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol AdditionalFeedInteractable {
    func getFeed(url: URL, completion: @escaping (Result<Feed, FeedError>) -> Void) -> Cancellable
}

class AdditionalFeedInteractor: AdditionalFeedInteractable {
    private let feedService: FeedService
    
    init(feedService: FeedService) {
        self.feedService = feedService
    }
    
    func getFeed(url: URL, completion: @escaping (Result<Feed, FeedError>) -> Void) -> Cancellable {
        feedService.getFeed(url: url, completion: completion)
    }
}

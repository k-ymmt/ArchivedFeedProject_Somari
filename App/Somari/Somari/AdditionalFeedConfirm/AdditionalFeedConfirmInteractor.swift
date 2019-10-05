//
//  AdditionalFeedConfirmInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/30.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol AdditionalFeedConfirmInteractable {
    
}

class AdditionalFeedConfirmInteractor: AdditionalFeedConfirmInteractable {
    private let feedService: FeedService

    init(feedService: FeedService) {
        self.feedService = feedService
    }
}

//
//  DependencyResolver.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/13.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariCore
import SomariFoundation

class DependencyResolver {
    let accountService: AccountService
    let feedService: FeedService
    let storageService: StorageService
    let feedItemCacheService: FeedItemCacheService

    init() {
        self.accountService = FirebaseAccountService()
        self.feedService = FeedKitService()
        self.storageService = FirebaseStorageService()
        self.feedItemCacheService = CoreDataFeedItemCacheService()
    }
}

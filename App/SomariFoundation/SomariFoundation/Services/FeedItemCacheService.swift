//
//  FeedItemCacheService.swift
//  SomariFoundation
//
//  Created by Kazuki Yamamoto on 2019/10/21.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

public protocol FeedItemCacheService {
    func addFeedItem(item: FeedItem) throws
    func addFeedItems(_ items: [FeedItem]) throws
    func getAllFeedItem(limit: Int, offset: Int) throws -> [FeedItem]?
    func getFeedItem<T>(
        limit: Int, offset: Int,
        sortedBy item: KeyPath<FeedItem, T?>, ascending: Bool
    ) throws -> [FeedItem]? where T: Comparable
}

//
//  DummyFeedItemCacheService.swift
//  FeedsSandbox
//
//  Created by Kazuki Yamamoto on 2019/10/22.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation

class DummyFeedItemCacheService: FeedItemCacheService {
    private var buffer: [FeedItem]
    
    init(initialBuffer: [FeedItem] = []) {
        self.buffer = initialBuffer
    }

    func addFeedItem(item: FeedItem) throws {
        buffer.append(item)
    }
    
    func addFeedItems(_ items: [FeedItem]) throws {
        buffer.append(contentsOf: items)
    }
    
    func getAllFeedItem(limit: Int, offset: Int) throws -> [FeedItem]? {
        return Array(buffer[offset..<limit])
    }
    
    func getFeedItem<T>(limit: Int, offset: Int, sortedBy item: KeyPath<FeedItem, T?>, ascending: Bool) throws -> [FeedItem]? where T: Comparable {
        var limit = limit
        if limit > buffer.count {
            limit = buffer.count
        }
        return buffer[offset..<limit]
            .sorted(by: {
            ascending ? $0[keyPath: item] < $1[keyPath: item] : $0[keyPath: item] > $1[keyPath: item]
        })
    }
}

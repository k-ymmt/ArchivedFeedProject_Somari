//
//  FeedItem.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

struct FeedItem {
    let title: String?
    let source: String?
    let link: String?
    let date: Date?
}

extension Feed {
    func feedItems() -> [FeedItem] {
        switch self {
        case .atom(let feed):
            return feed.entries?.map { FeedItem(
                title: $0.title,
                source: feed.title,
                link: $0.links?.first?.href,
                date: $0.updated ?? $0.published
            ) } ?? []
        case .rss(let feed):
            return feed.items?.map { FeedItem(
                title: $0.title,
                source: feed.channel?.title,
                link: $0.link,
                date: $0.pubDate
            ) } ?? []
        }
    }
}

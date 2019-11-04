//
//  FeedItem.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

public struct FeedItem: Hashable {
    public let title: String?
    public let id: String
    public let feedID: String?
    public let source: String?
    public let link: String?
    public let date: Date?

    public init(title: String?, id: String, feedID: String?, source: String?, link: String?, date: Date?) {
        self.title = title
        self.id = id
        self.feedID = feedID
        self.source = source
        self.link = link
        self.date = date
    }
}

extension Feed {
    public func feedItems() -> [FeedItem] {
        switch self {
        case .atom(let feed):
            return feed.entries?.map { FeedItem(
                title: $0.title,
                id: $0.id ?? "",
                feedID: $0.id,
                source: feed.title,
                link: $0.links?.first?.href,
                date: $0.updated ?? $0.published
            ) } ?? []
        case .rss(let feed):
            return feed.items?.map { FeedItem(
                title: $0.title,
                id: $0.guid ?? "",
                feedID: $0.guid,
                source: feed.channel?.title,
                link: $0.link,
                date: $0.pubDate
            ) } ?? []
        }
    }
}

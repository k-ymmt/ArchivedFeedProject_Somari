//
//  RSSService.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import FeedKit
import SomariKit

class FeedKitService: FeedService {
    func getFeed(url: URL, completion: @escaping (Swift.Result<Feed, FeedError>) -> Void) -> Cancellable {
        let parser = FeedParser(URL: url)
        parser.parseAsync(queue: .global(qos: .userInitiated)) { (result) in
            switch result {
            case .atom(let feed):
                completion(.success(.atom(AtomFeed(feed: feed))))
            case .rss(let feed):
                completion(.success(.rss(RSSFeed(feed: feed))))
            case .json(let feed):
                print(feed)
                print("not supported")
            case .failure(let error):
                completion(.failure(.unknown(error)))
            }
        }
        
        return Canceler {
            parser.abortParsing()
        }
    }
}

extension SomariKit.AtomFeed {
    init(feed: FeedKit.AtomFeed) {
        self = .init(
            id: feed.id,
            title: feed.title,
            description: feed.subtitle?.value,
            updated: feed.updated,
            authors: feed.authors?.map { SomariKit.AtomFeed.Author(author: $0) },
            entries: feed.entries?.map { SomariKit.AtomFeed.Entry(entry: $0) }
        )
    }
}

extension SomariKit.AtomFeed.Author {
    init(author: FeedKit.AtomFeedAuthor) {
        self = .init(name: author.name)
    }
    
    init(author: FeedKit.AtomFeedEntryAuthor) {
        self = .init(name: author.name)
    }
}

extension SomariKit.AtomFeed.Entry {
    init(entry: FeedKit.AtomFeedEntry) {
        self = .init(
            id: entry.id,
            authors: entry.authors?.map { SomariKit.AtomFeed.Author(author: $0) },
            published: entry.published,
            updated: entry.updated,
            links: entry.links?.compactMap { SomariKit.AtomFeed.Entry.Link(attributes: $0.attributes) },
            title: entry.title,
            content: SomariKit.AtomFeed.Entry.Content(content: entry.content)
        )
    }
}

extension SomariKit.AtomFeed.Entry.Content {
    init?(content: FeedKit.AtomFeedEntryContent?) {
        guard let content = content else {
            return nil
        }
        
        self = .init(
            type: SomariKit.AtomFeed.Entry.Content.ContentType(attribute: content.attributes),
            value: content.value
        )
    }
}

extension SomariKit.AtomFeed.Entry.Content.ContentType {
    init?(attribute: FeedKit.AtomFeedEntryContent.Attributes?) {
        switch attribute?.type {
        case "html":
            self = .html
        default:
            return nil
        }
    }
}

extension SomariKit.AtomFeed.Entry.Link {
    init?(attributes: FeedKit.AtomFeedEntryLink.Attributes?) {
        guard let attributes = attributes else {
            return nil
        }
        self = .init(
            type: SomariKit.AtomFeed.Entry.Link.LinkType(type: attributes.type),
            href: attributes.href
        )
    }
}

extension SomariKit.AtomFeed.Entry.Link.LinkType {
    init?(type: String?) {
        guard let type = type else {
            return nil
        }
        switch type {
        case "text/html":
            self = .html
        default:
            return nil
        }
    }
}

extension SomariKit.RSSFeed {
    init(feed: FeedKit.RSSFeed) {
        self = .init(
            channel: SomariKit.RSSFeed.Channel(feed: feed),
            items: feed.items?.map { SomariKit.RSSFeed.Item(feed: $0) }
        )
    }
}

extension SomariKit.RSSFeed.Channel {
    init(feed: FeedKit.RSSFeed) {
        self = .init(
            title: feed.title,
            description: feed.description,
            pubDate: feed.pubDate
        )
    }
}

extension SomariKit.RSSFeed.Item {
    init(feed: FeedKit.RSSFeedItem) {
        self = .init(
            title: feed.title,
            guid: feed.guid?.value,
            link: feed.link,
            description: feed.description,
            pubDate: feed.pubDate
        )
    }
}

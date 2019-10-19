//
//  RSSService.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import FeedKit
import SomariFoundation

public class FeedKitService: FeedService {
    public init() {
    }

    public func getFeed(url: URL, completion: @escaping (Swift.Result<SomariFoundation.Feed, FeedError>) -> Void) -> Cancellable {
        let parser = FeedParser(URL: url)
        parser.parseAsync(queue: .global(qos: .userInitiated)) { (result) in
            switch result {
            case .success(let feed):
                switch feed {
                case .atom(let feed):
                    completion(.success(.atom(AtomFeed(feed: feed))))
                case .rss(let feed):
                    completion(.success(.rss(RSSFeed(feed: feed))))
                case .json(let feed):
                    print(feed)
                    print("not supported")
                }
            case .failure(let error):
                completion(.failure(.unknown(error)))
            }
        }

        return Canceler {
            parser.abortParsing()
        }
    }
}

private extension SomariFoundation.AtomFeed {
    init(feed: FeedKit.AtomFeed) {
        self = .init(
            id: feed.id,
            title: feed.title,
            description: feed.subtitle?.value,
            updated: feed.updated,
            authors: feed.authors?.map { SomariFoundation.AtomFeed.Author(author: $0) },
            entries: feed.entries?.map { SomariFoundation.AtomFeed.Entry(entry: $0) }
        )
    }
}

private extension SomariFoundation.AtomFeed.Author {
    init(author: FeedKit.AtomFeedAuthor) {
        self = .init(name: author.name)
    }

    init(author: FeedKit.AtomFeedEntryAuthor) {
        self = .init(name: author.name)
    }
}

private extension SomariFoundation.AtomFeed.Entry {
    init(entry: FeedKit.AtomFeedEntry) {
        self = .init(
            id: entry.id,
            authors: entry.authors?.map { SomariFoundation.AtomFeed.Author(author: $0) },
            published: entry.published,
            updated: entry.updated,
            links: entry.links?.compactMap { SomariFoundation.AtomFeed.Entry.Link(attributes: $0.attributes) },
            title: entry.title,
            content: SomariFoundation.AtomFeed.Entry.Content(content: entry.content)
        )
    }
}

private extension SomariFoundation.AtomFeed.Entry.Content {
    init?(content: FeedKit.AtomFeedEntryContent?) {
        guard let content = content else {
            return nil
        }

        self = .init(
            type: SomariFoundation.AtomFeed.Entry.Content.ContentType(attribute: content.attributes),
            value: content.value
        )
    }
}

private extension SomariFoundation.AtomFeed.Entry.Content.ContentType {
    init?(attribute: FeedKit.AtomFeedEntryContent.Attributes?) {
        switch attribute?.type {
        case "html":
            self = .html
        default:
            return nil
        }
    }
}

private extension SomariFoundation.AtomFeed.Entry.Link {
    init?(attributes: FeedKit.AtomFeedEntryLink.Attributes?) {
        guard let attributes = attributes else {
            return nil
        }
        self = .init(
            type: SomariFoundation.AtomFeed.Entry.Link.LinkType(type: attributes.type),
            href: attributes.href
        )
    }
}

private extension SomariFoundation.AtomFeed.Entry.Link.LinkType {
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

private extension SomariFoundation.RSSFeed {
    init(feed: FeedKit.RSSFeed) {
        self = .init(
            channel: SomariFoundation.RSSFeed.Channel(feed: feed),
            items: feed.items?.map { SomariFoundation.RSSFeed.Item(feed: $0) }
        )
    }
}

private extension SomariFoundation.RSSFeed.Channel {
    init(feed: FeedKit.RSSFeed) {
        self = .init(
            title: feed.title,
            description: feed.description,
            pubDate: feed.pubDate
        )
    }
}

private extension SomariFoundation.RSSFeed.Item {
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

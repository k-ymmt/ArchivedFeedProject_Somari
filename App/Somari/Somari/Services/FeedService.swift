//
//  RSSService.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import FeedKit

protocol Cancellable {
    func cancel()
}

struct Canceler: Cancellable {
    private let action: () -> Void
    init(action: @escaping () -> Void) {
        self.action = action
    }
    func cancel() {
        action()
    }
}

enum FeedError: Error {
    case unknown(Error)
}

protocol FeedService {
    func getFeed(url: URL, completion: @escaping (Swift.Result<Feed, FeedError>) -> Void) -> Cancellable
}

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

extension AtomFeed {
    init(feed: FeedKit.AtomFeed) {
        self.id = feed.id
        self.authors = feed.authors?.map { Author(author: $0) }
        self.title = feed.title
        self.description = feed.subtitle?.value
        self.updated = feed.updated
        self.entries = feed.entries?.map { Entry(entry: $0) }
    }
}

extension AtomFeed.Author {
    init(author: FeedKit.AtomFeedAuthor) {
        name = author.name
    }
    
    init(author: FeedKit.AtomFeedEntryAuthor) {
        name = author.name
    }
}

extension AtomFeed.Entry {
    init(entry: FeedKit.AtomFeedEntry) {
        self.authors = entry.authors?.map { AtomFeed.Author(author: $0) }
        self.content = Content(content: entry.content)
        self.id = entry.id
        self.published = entry.published
        self.title = entry.title
        self.updated = entry.updated
        self.links = entry.links?.compactMap { Link(attributes: $0.attributes) }
    }
}

extension AtomFeed.Entry.Content {
    init?(content: FeedKit.AtomFeedEntryContent?) {
        guard let content = content else {
            return nil
        }
        self.type = ContentType(attribute: content.attributes)
        self.value = content.value
    }
}

extension AtomFeed.Entry.Content.ContentType {
    init?(attribute: FeedKit.AtomFeedEntryContent.Attributes?) {
        switch attribute?.type {
        case "html":
            self = .html
        default:
            return nil
        }
    }
}

extension AtomFeed.Entry.Link {
    init?(attributes: FeedKit.AtomFeedEntryLink.Attributes?) {
        guard let attributes = attributes else {
            return nil
        }
        self.href = attributes.href
        self.type = LinkType(type: attributes.type)
    }
}

extension AtomFeed.Entry.Link.LinkType {
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

extension RSSFeed {
    init(feed: FeedKit.RSSFeed) {
        self.channel = Channel(feed: feed)
        self.items = feed.items?.map { Item(feed: $0) }
    }
}

extension RSSFeed.Channel {
    init(feed: FeedKit.RSSFeed) {
        self.description = feed.description
        self.title = feed.title
        self.pubDate = feed.pubDate
    }
}

extension RSSFeed.Item {
    init(feed: FeedKit.RSSFeedItem) {
        self.description = feed.description
        self.link = feed.link
        self.pubDate = feed.pubDate
        self.title = feed.title
    }
}

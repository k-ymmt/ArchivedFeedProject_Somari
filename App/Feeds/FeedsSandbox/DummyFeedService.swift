//
//  DummyFeedService.swift
//  FeedsSandbox
//
//  Created by Kazuki Yamamoto on 2019/10/14.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation

class DummyFeedService: FeedService {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return formatter
    }()

    func getFeed(url: URL, completion: @escaping (Result<Feed, FeedError>) -> Void) -> Cancellable {
        var feeds: [AtomFeed.Entry] = []

        for i in 0..<Int.random(in: 0..<10) {
            let id = Int.random(in: 0...500)
            feeds.append(.init(
                id: "\(id)",
                authors: [],
                published: Date.init(timeIntervalSinceNow: -Double.random(in: 0...1000)),
                updated: nil,
                links: [.init(type: .html, href: "https://google.com")],
                title: "\(i) - \(id)",
                content: .init(type: .html, value: ""))
            )
        }

        let logString = feeds.map {
            "title: \($0.title!) "
            + "id: \($0.id!),
            + "published: \(dateFormatter.string(from: $0.published!))"
        }.joined(separator: "\n")
        Logger.info("\n\()")

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(.success(.atom(.init(
                id: "a",
                title: "Dummy",
                description: "Dummy feed",
                updated: Date(),
                authors: [],
                entries: feeds
            ))))
        }

        return Canceler {
        }
    }
}

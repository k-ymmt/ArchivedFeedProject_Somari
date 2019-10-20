//
//  FeedService.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

public protocol Cancellable {
    func cancel()
}

extension SomariFoundation.Cancellable {
    public var toCombine: Combine.Cancellable {
        return Combine.AnyCancellable {
            self.cancel()
        }
    }
}

public struct Canceler: Cancellable {
    private let action: () -> Void
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    public func cancel() {
        action()
    }
}

public enum FeedError: Error {
    case unknown(Error)
}

public protocol FeedService: class {
    func getFeed(url: URL, completion: @escaping (Swift.Result<Feed, FeedError>) -> Void) -> Cancellable
}

extension FeedService {
    public func getFeeds(urls: [URL], completion: @escaping (Swift.Result<[Feed], FeedError>) -> Void) -> Cancellable {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global(qos: .default)
        var feeds: [Feed] = []
        var cancellables: [Cancellable] = []
        var error: FeedError?
        for url in urls {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) { [weak self] in
                guard let self = self else {
                    return
                }
                cancellables.append(self.getFeed(url: url) { (result) in
                    switch result {
                    case .success(let feed):
                        feeds.append(feed)
                    case .failure(let err):
                        error = err
                    }
                    dispatchGroup.leave()
                })
            }
        }

        dispatchGroup.notify(queue: .global(qos: .default)) {
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(feeds))
        }

        return Canceler {
            for cancellable in cancellables {
                cancellable.cancel()
            }
        }
    }
}

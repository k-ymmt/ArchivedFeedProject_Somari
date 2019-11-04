//
//  FeedsInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation
import Combine

protocol FeedsInteractable {
    var feeds: PropertyPublisher<[FeedItem]> { get }
    var userSettings: PropertyPublisher<[UserSettingsFeedData]> { get }
    var errorPublisher: EventPublisher<Error> { get }
    func getFeed(url: URL) -> Combine.Cancellable
    func getFeeds(urls: [URL]) -> Combine.Cancellable
    func getInitialFeedItemFromCache()
    func subscribeUserSettings() -> Combine.Cancellable
}

class FeedsInteractor: FeedsInteractable {
    private let feedService: FeedService
    private let storageService: StorageService
    private let loginService: LoginService
    private let feedItemCacheService: FeedItemCacheService

    private let getFeedDispatchQueue: DispatchQueue = DispatchQueue(
        label: "net.kymmt.Somari.Feeds.getFeedsQueue",
        qos: .utility,
        attributes: .concurrent
    )

    private let diffAndSortQueue: DispatchQueue = DispatchQueue(
        label: "net.kymmt.Somari.Feeds.diffAndSortQueue",
        qos: .userInitiated
    )

    @PropertyPublished(defaultValue: []) var userSettings: PropertyPublisher<[UserSettingsFeedData]>
    @PropertyPublished(defaultValue: []) var feeds: PropertyPublisher<[FeedItem]>
    @EventPublished var errorPublisher: EventPublisher<Error>

    init(
        feedService: FeedService,
        storageService: StorageService,
        loginService: LoginService,
        feedItemCacheService: FeedItemCacheService
    ) {
        self.feedService = feedService
        self.storageService = storageService
        self.loginService = loginService
        self.feedItemCacheService = feedItemCacheService
    }

    func subscribeUserSettings() -> Combine.Cancellable {
        guard let uid = loginService.uid() else {
            Logger.error(LoginError.notLogin)
            return AnyCancellable({})
        }
        return storageService.subscribeValues(key: UserSettingsFeedData.key(uid: uid)) { [weak self] (result: Result<[UserSettingsFeedData], Error>) in
            switch result {
            case .success(let dataList):
                self?._userSettings.value = dataList
            case .failure(let error):
                Logger.error(error)
            }
        }.toCombine
    }

    func getInitialFeedItemFromCache() {
        getFeedDispatchQueue.async {
            guard let caches = try? self.feedItemCacheService.getFeedItem(limit: 50, offset: 0, sortedBy: \FeedItem.date, ascending: false) else {
                return
            }
            Logger.debug(caches.map { "title: \($0.title ?? "") id: \($0.id) published: \($0.date?.description ?? "")" }.joined(separator: "\n"))
            self._feeds.value = caches
        }
    }

    func getFeed(url: URL) -> Combine.Cancellable {
        return feedService.getFeed(url: url, queue: getFeedDispatchQueue) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let feeds):
                let items = feeds.feedItems()
                self.updateFeedItems(items: items)
            case .failure(let error):
                self._errorPublisher.send(error)
            }
        }.toCombine
    }

    func getFeeds(urls: [URL]) -> Combine.Cancellable {
        return feedService.getFeeds(urls: urls, queue: getFeedDispatchQueue) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let feeds):
                let items = feeds.flatMap { $0.feedItems() }
                self.updateFeedItems(items: items)
            case .failure(let error):
                self._errorPublisher.send(error)
            }
        }.toCombine
    }

    // MARK: FeedItems Utilities

    private func updateFeedItems(items: [FeedItem]) {
        updateFeedItems(items: items, selector: { $0.id })
    }

    private func updateFeedItems<T>(items: [FeedItem], selector: @escaping (FeedItem) -> T) where T: Comparable {
        diffAndSortQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            let diff = self.getDiffFeedItems(source: self.feeds.value, items: items, selector: selector)
            try? self.feedItemCacheService.addFeedItems(diff)
            self._feeds.value = diff + self.feeds.value
        }
    }

    private func getDiffFeedItems<T>(source: [FeedItem], items: [FeedItem], selector: (FeedItem) -> T) -> [FeedItem] where T: Comparable {
        var buffer: [FeedItem] = []
        do {
            for item in items {
                guard try !feedItemCacheService.contains(key: \.id, value: item.id) else {
                    continue
                }
                buffer.append(item)
            }
        } catch {
            Logger.error(error)
            return []
        }

        return sortedFeedItems(buffer)
    }

    private func sortedFeedItems(_ items: [FeedItem]) -> [FeedItem] {
        return items.sorted(by: { $0.date > $1.date })
    }
}

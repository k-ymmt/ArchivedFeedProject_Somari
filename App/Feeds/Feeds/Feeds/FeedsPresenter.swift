//
//  FeedsPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine
import SomariFoundation
import SomariKit

protocol FeedsPresentable {
    var feeds: PropertyPublisher<[FeedItem]> { get }

    func getFeeds(url: URL)
    func getFeedAll()
    func showWebPage(linkString: String)
}

class FeedsPresenter: FeedsPresentable {

    private let router: FeedsRoutable
    private let interactor: FeedsInteractable

    private var cancellables: Set<AnyCancellable> = Set()
    private var feedDataList: [UserSettingsFeedData] = []

    @PropertyPublished(defaultValue: []) var feeds: PropertyPublisher<[FeedItem]>

    init(router: FeedsRoutable, interactor: FeedsInteractable) {
        self.router = router
        self.interactor = interactor

        self.interactor.feeds
            .sink { [weak self] values in
                self?._feeds.value = values
        }.store(in: &cancellables)

        interactor.getInitialFeedItemFromCache()

        interactor.userSettings
            .sink(receiveCompletion: { _ in }) { [weak self] (dataList) in
                self?.feedDataList = dataList
                self?.getFeedAll()
        }.store(in: &cancellables)

        interactor.subscribeUserSettings().store(in: &cancellables)
    }

    func getFeeds(url: URL) {
        interactor.getFeed(url: url).store(in: &cancellables)
    }

    func getFeedAll() {
        let urls = feedDataList.compactMap { URL(string: $0.url) }
        Logger.debug("get feed all\n\(urls.map { "  - \($0.absoluteString)" }.joined(separator: "\n"))")
        interactor.getFeeds(urls: urls).store(in: &cancellables)
    }

    func showWebPage(linkString: String) {
        guard let url = URL(string: linkString) else {
            return
        }

        router.showSafariViewController(url: url)
    }

    private func receivedUserSettings(result: Result<[UserSettingsFeedData], Error>) {
        switch result {
        case .success(let feedInfoList):
            self.feedDataList = feedInfoList
            self.getFeedAll()
        case .failure(let error):
            Logger.debug("\(error)")
        }
    }

    deinit {
        Logger.debug("\(String(describing: self)) deinit")
    }
}

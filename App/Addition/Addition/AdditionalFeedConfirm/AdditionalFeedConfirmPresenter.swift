//
//  AdditionalFeedConfirmPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/30.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation

protocol AdditionalFeedConfirmPresentable {
    var feedItems: PropertyPublisher<[FeedItem]> { get }

    func saveFeedInfo()
    func showWebPage(linkString: String)
}

class AdditionalFeedConfirmPresenter: AdditionalFeedConfirmPresentable {
    struct FeedInfo {
        let url: URL
        let title: String?
        let items: [FeedItem]
    }
    private let router: AdditionalFeedConfirmRoutable
    private let interactor: AdditionalFeedConfirmInteractable

    private let info: FeedInfo

    @PropertyPublished var feedItems: PropertyPublisher<[FeedItem]>

    init(
        info: FeedInfo,
        router: AdditionalFeedConfirmRoutable,
        interactor: AdditionalFeedConfirmInteractable
    ) {
        self.info = info
        self._feedItems = PropertyPublished(defaultValue: info.items)
        self.router = router
        self.interactor = interactor
    }

    func saveFeedInfo() {
        interactor.saveFeedInfo(info: UserSettingsFeedData(group: "/", url: info.url.absoluteString, title: info.title)) { [weak self] (result) in
            switch result {
            case .success:
                self?.router.additionSuccess()
            case .failure(let error):
                Logger.debug("\(error)")
            }
        }
    }

    func showWebPage(linkString: String) {
        guard let url = URL(string: linkString) else {
            return
        }

        router.showSafariViewController(url: url)
    }
}

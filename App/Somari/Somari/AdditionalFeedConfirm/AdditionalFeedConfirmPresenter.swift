//
//  AdditionalFeedConfirmPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/30.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol AdditionalFeedConfirmPresentable {
    var feedItems: PropertyPublisher<[FeedItem]> { get }

    func saveFeedInfo()
    func showWebPage(linkString: String)
}

class AdditionalFeedConfirmPresenter: AdditionalFeedConfirmPresentable {
    private let router: AdditionalFeedConfirmRoutable
    private let interactor: AdditionalFeedConfirmInteractable
    
    private let url: URL
    
    @PropertyPublished var feedItems: PropertyPublisher<[FeedItem]>

    init(
        url: URL,
        feedItems: [FeedItem],
        router: AdditionalFeedConfirmRoutable,
        interactor: AdditionalFeedConfirmInteractable
    ) {
        self.url = url
        self._feedItems = PropertyPublished(defaultValue: feedItems)
        self.router = router
        self.interactor = interactor
    }
    
    func saveFeedInfo() {
        interactor.saveFeedInfo(info: FeedInfo(url: url.absoluteString, title: "")) { [weak self] (result) in
            switch result {
            case .success:
                self?.router.popToRoot()
            case .failure(let error):
                logger.debug("\(error)")
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

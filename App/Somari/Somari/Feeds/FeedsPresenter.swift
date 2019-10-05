//
//  FeedsPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

protocol FeedsPresentable {
    var feeds: PropertyPublisher<[FeedItem]> { get }
    
    func getFeeds()
    func navigateToAdditionalFeed()
    func showWebPage(linkString: String)
}

class FeedsPresenter: FeedsPresentable {
    private let router: FeedsRoutable
    private let interactor: FeedsInteractable

    @PropertyPublished(defaultValue: []) var feeds: PropertyPublisher<[FeedItem]>
    
    init(router: FeedsRoutable, interactor: FeedsInteractable) {
        self.router = router
        self.interactor = interactor
    }
    
    func getFeeds() {
//        self._feeds.value = [FeedItem(title: "hogehoge") ]
        interactor.getFeed(url: URL(string: "https://qiita.com/tags/swift/feed")!) { [weak self] (result) in
            switch result {
            case .success(let feed):
                switch feed {
                case .atom(let atomFeed):
                    if let entries = atomFeed.entries {
                        self!._feeds.value += entries.map { FeedItem(title: $0.title, source: atomFeed.title, link: $0.links?.first?.href) }
                    }
                case .rss(let rssFedd):
                    if let items = rssFedd.items {
                        self?._feeds.value += items.map { FeedItem(title: $0.title, source: rssFedd.channel?.title, link: $0.link) }
                    }
                }
                self?._feeds.forceNotify()
            case .failure(let error):
                break
            }
        }
    }

    func navigateToAdditionalFeed() {
        router.navigateAdditionalFeedView()
    }
    
    func showWebPage(linkString: String) {
        guard let url = URL(string: linkString) else {
            return
        }
        
        router.showSafariViewController(url: url)
    }
}

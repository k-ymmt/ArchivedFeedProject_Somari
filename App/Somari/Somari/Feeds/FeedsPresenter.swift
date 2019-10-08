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
    
    func getFeeds(url: URL)
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
        
        interactor.getUserSettings(completion: receivedUserSettings(result:))
    }
    
    func getFeeds(url: URL) {
        interactor.getFeed(url: url) { [weak self] (result) in
            switch result {
            case .success(let feed):
                self?._feeds.value += feed.feedItems()
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
    
    private func receivedUserSettings(result: Result<[FeedInfo], Error>) {
        switch result {
        case .success(let feedInfoList):
            for info in feedInfoList {
                guard let url = URL(string: info.url) else {
                    logger.debug("invalid url: \(info.url)")
                    return
                }
                
                getFeeds(url: url)
            }
        case .failure(let error):
            logger.debug("\(error)")
        }
    }
    
    
}

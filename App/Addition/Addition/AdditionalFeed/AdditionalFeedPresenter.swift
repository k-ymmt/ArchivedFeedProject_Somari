//
//  AdditionalFeedPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine
import SomariFoundation

protocol AdditionalFeedPresentable {
    var getFeedSuccess: EventPublisher<Bool> { get }

    func getFeed(urlString: String)
}

class AdditionalFeedPresenter: AdditionalFeedPresentable {
    private let router: AdditionalFeedRoutable
    private let interactor: AdditionalFeedInteractable

    private var cancellables: Set<AnyCancellable> = Set()

    @EventPublished
    var errorPublisher: EventPublisher<AdditionalFeedError>

    @EventPublished
    var getFeedSuccess: EventPublisher<Bool>

    init(
        router: AdditionalFeedRoutable,
        interactor: AdditionalFeedInteractable
    ) {
        self.router = router
        self.interactor = interactor

        self.interactor.subscribeUserSettings().store(in: &cancellables)
        self.interactor.getFeedsSuccess
            .sink { [weak self] (url, feeds) in
                self?.router.navigateToAdditionalFeedConfirm(url: url, title: feeds.title, items: feeds.feedItems())
                self?._getFeedSuccess.send(true)
        }.store(in: &cancellables)
        self.interactor.errorPublisher
            .sink { [weak self] (error) in
                self?._errorPublisher.send(error)
        }.store(in: &cancellables)
    }

    func getFeed(urlString: String) {
        interactor.getFeed(urlString: urlString).store(in: &cancellables)
    }

    deinit {
        cancellables.cancel()
    }
}

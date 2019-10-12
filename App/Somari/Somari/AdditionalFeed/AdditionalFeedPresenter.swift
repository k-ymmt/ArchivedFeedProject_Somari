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

enum AdditionalFeedError {
    case invalidURL
    case notFeedURL
}

protocol AdditionalFeedPresentable {
    var getFeedSuccess: EventPublisher<Bool> { get }

    func getFeed(urlString: String)
    func dismiss()
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
    }
    
    func getFeed(urlString: String) {
        guard let url = URL(string: urlString) else {
            _errorPublisher.send(.invalidURL)
            return
        }
        interactor.getFeed(url: url) { [weak self] (result) in
            switch result {
            case .success(let feed):
                self?.router.navigateToAdditionalFeedConfirm(url: url, title: feed.title, items: feed.feedItems())
                self?._getFeedSuccess.send(true)
            case .failure(let error):
                Logger.error("\(error.localizedDescription)")
                break
            }
        }.toCombine.store(in: &cancellables)
    }

    func dismiss() {
        router.dismiss()
    }
    
    deinit {
        cancellables.cancel()
    }
}

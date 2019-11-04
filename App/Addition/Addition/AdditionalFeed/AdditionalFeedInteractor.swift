//
//  AdditionalFeedInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation
import Combine

enum AdditionalFeedError {
    case invalidURL
    case notFeedURL
    case getFeedFailed
}

protocol AdditionalFeedInteractable {
    var getFeedsSuccess: EventPublisher<(URL, Feed)> { get }
    var errorPublisher: EventPublisher<AdditionalFeedError> { get }

    func subscribeUserSettings() -> Combine.Cancellable
    func checkAlreadyRegistered(_ urlString: String) -> Bool
    func getFeed(urlString: String) -> Combine.Cancellable
}

class AdditionalFeedInteractor: AdditionalFeedInteractable {
    private let feedService: FeedService
    private let storageService: StorageService
    private let loginService: LoginService

    private let getFeedDispatchQueue: DispatchQueue = DispatchQueue(
        label: "net.kymmt.Somari.Addition.getFeedQueue",
        qos: .userInitiated,
        attributes: .concurrent
    )

    private var userSettings: [UserSettingsFeedData] = []

    @EventPublished var getFeedsSuccess: EventPublisher<(URL, Feed)>
    @EventPublished var errorPublisher: EventPublisher<AdditionalFeedError>

    init(feedService: FeedService, loginService: LoginService, storageService: StorageService) {
        self.feedService = feedService
        self.loginService = loginService
        self.storageService = storageService
    }

    func subscribeUserSettings() -> Combine.Cancellable {
        guard let uid = loginService.uid() else {
            return AnyCancellable({})
        }
        return self.storageService.subscribeValues(
            key: UserSettingsFeedData.key(uid: uid)
        ) { [weak self] (result: Result<[UserSettingsFeedData], Error>) in
            switch result {
            case .success(let userSettings):
                self?.userSettings = userSettings
            case .failure(let error):
                Logger.error(error)
            }
        }.toCombine
    }

    func checkAlreadyRegistered(_ urlString: String) -> Bool {
        return userSettings.map({ $0.url }).contains(urlString)
    }

    func getFeed(urlString: String) -> Combine.Cancellable {
        guard let url = URL(string: urlString) else {
            _errorPublisher.send(.invalidURL)
            return AnyCancellable({})
        }
        return feedService.getFeed(url: url, queue: getFeedDispatchQueue) { [weak self] result in
            switch result {
            case .success(let feeds):
                self?._getFeedsSuccess.send((url, feeds))
            case .failure(let error):
                Logger.error(error)
                self?._errorPublisher.send(.getFeedFailed)
            }
        }.toCombine
    }
}

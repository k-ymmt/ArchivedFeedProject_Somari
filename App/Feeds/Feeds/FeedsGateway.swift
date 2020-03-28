//
//  FeedsGateway.swift
//  Feeds
//
//  Created by Kazuki Yamamoto on 2019/10/13.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import SomariFoundation

public enum FeedsNavigateAction {
    case gotoAdditionView
}

public class FeedsGateway: Gateway {
    public struct Dependency {
        let feedService: FeedService
        let storageService: StorageService
        let accountService: AccountService
        let feedItemCacheService: FeedItemCacheService

        public init(
            feedService: FeedService,
            storageService: StorageService,
            accountService: AccountService,
            feedItemCacheService: FeedItemCacheService) {
            self.feedService = feedService
            self.storageService = storageService
            self.accountService = accountService
            self.feedItemCacheService = feedItemCacheService
        }
    }

    public enum Input {
        case showFeeds
    }

    public enum Output {
        case showFeeds(UIViewController)
        case gotoAdditionView
    }

    private let dependency: Dependency
    private var outputAction: ((FeedsGateway.Output) -> Void)?

    public required init(dependency: FeedsGateway.Dependency) {
        self.dependency = dependency
    }

    public func input(_ value: FeedsGateway.Input) {
        switch value {
        case .showFeeds:
            outputAction?(.showFeeds(makeFeedsPage()))
        }
    }

    public func output(_ action: @escaping (FeedsGateway.Output) -> Void) {
        self.outputAction = action
    }

    private func makeFeedsPage() -> UIViewController {
        let viewController = FeedsRouter.assembleModules(dependency: .init(
            feedService: dependency.feedService,
            storageService: dependency.storageService,
            accountService: dependency.accountService,
            feedItemCacheService: dependency.feedItemCacheService
        ))  { [weak self] action in
            self?.outputAction?(.gotoAdditionView)
        }

        return viewController
    }
}

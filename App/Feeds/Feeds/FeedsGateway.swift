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

public class FeedsGateway: Gateway {
    public struct Dependency {
        let feedService: FeedService
        let storageService: StorageService
        let loginService: LoginService
        
        public init(feedService: FeedService, storageService: StorageService, loginService: LoginService) {
            self.feedService = feedService
            self.storageService = storageService
            self.loginService = loginService
        }
    }
    
    public enum Input {
        case showFeeds
    }
    
    public enum Output {
        case showFeeds(UIViewController)
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
            loginService: dependency.loginService
        ))
        
        return viewController
    }
}

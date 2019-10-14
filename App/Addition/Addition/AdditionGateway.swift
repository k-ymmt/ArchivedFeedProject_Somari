//
//  AdditionalGateway.swift
//  Additional
//
//  Created by Kazuki Yamamoto on 2019/10/13.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import SomariFoundation

public class AdditionGateway: Gateway {
    public struct Dependency {
        let feedService: FeedService
        let loginService: LoginService
        let storageService: StorageService
        
        public init(feedService: FeedService, loginService: LoginService, storageService: StorageService) {
            self.feedService = feedService
            self.loginService = loginService
            self.storageService = storageService
        }
    }
    
    public enum Input {
        case showAdditionalFeed
    }
    
    public enum Output {
        case showAdditionalFeed(UIViewController)
    }
    
    private let dependency: Dependency
    private var outputAction: ((Output) -> Void)?
    
    public required init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    public func input(_ value: AdditionGateway.Input) {
        switch value {
        case .showAdditionalFeed:
            let viewController = makeAdditionalFeedPage()
            outputAction?(.showAdditionalFeed(viewController))
        }
    }
    
    public func output(_ action: @escaping (AdditionGateway.Output) -> Void) {
        self.outputAction = action
    }
}

private extension AdditionGateway {
    func makeAdditionalFeedPage() -> UIViewController {
        let viewController = AdditionalFeedRouter.assembleModules(dependency: .init(
            feedService: dependency.feedService,
            loginService: dependency.loginService,
            storageService: dependency.storageService
        )) { [weak self] (output) in
            
        }
        
        return viewController
    }
}

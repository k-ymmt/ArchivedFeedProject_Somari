//
//  FeedsRouter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

protocol FeedsRoutable {
}

struct FeedsRouter: FeedsRoutable {
    static func assembleModules() -> UIViewController {
        let router = FeedsRouter()
        let feedsService = FeedKitService()
        let interactor = FeedsInteractor(feedService: feedsService)
        let presenter = FeedsPresenter(router: router, interactor: interactor)
        let viewControlelr = FeedsViewController(presenter: presenter)
        
        return UINavigationController(rootViewController: viewControlelr)
    }
    
    func navigateFeeds() {
        
    }
}

//
//  AdditionalFeedConfirmPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/30.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol AdditionalFeedConfirmPresentable {
    func showWebPage(linkString: String)
}

class AdditionalFeedConfirmPresenter: AdditionalFeedConfirmPresentable {
    let router: AdditionalFeedConfirmRoutable
    let interactor: AdditionalFeedConfirmInteractable

    init(
        router: AdditionalFeedConfirmRoutable,
        interactor: AdditionalFeedConfirmInteractable
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    func showWebPage(linkString: String) {
        guard let url = URL(string: linkString) else {
            return
        }
        
        router.showSafariViewController(url: url)
    }
}

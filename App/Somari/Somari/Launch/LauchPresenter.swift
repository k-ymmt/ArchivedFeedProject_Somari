//
//  LauchPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/06.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

protocol LaunchPresentable {
    func tryLogin()
}

class LaunchPresenter: LaunchPresentable {
    private let interactor: LaunchInteractable
    private let router: LaunchRoutable
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    init(interactor: LaunchInteractable, router: LaunchRoutable) {
        self.interactor = interactor
        self.router = router
    }
    
    func tryLogin() {
        interactor.tryLogin()
            .sink(receiveCompletion: { _ in }) { [weak self] (success) in
                if success {
                    self?.router.navigateToMain()
                } else {
                    self?.router.showLoginPage()
                }
        }.store(in: &cancellables)
    }
    
    deinit {
        cancellables.cancel()
    }
}

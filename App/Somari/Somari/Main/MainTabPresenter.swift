//
//  MainTabPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

protocol MainTabPresentable {
}

class MainTabPresenter: MainTabPresentable {
    private let interactor: MainTabInteractable
    private let router: MainTabRoutable

    private var cancellables: Set<AnyCancellable> = Set()

    init(interactor: MainTabInteractable, router: MainTabRoutable) {
        self.interactor = interactor
        self.router = router
    }
}

//
//  LauchPresenter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/06.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol LaunchPresentable {
}

class LaunchPresenter: LaunchPresentable {
    private let interactor: LaunchInteractable
    private let router: LaunchRoutable
    
    init(interactor: LaunchInteractable, router: LaunchRoutable) {
        self.interactor = interactor
        self.router = router
    }
}

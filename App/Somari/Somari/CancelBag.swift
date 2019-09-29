//
//  CancelBag.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

class CancelBag {
    private var cancels: [AnyCancellable] = []
    
    func append(_ element: AnyCancellable) {
        cancels.append(element)
    }
    
    deinit {
        for cancel in cancels {
            cancel.cancel()
        }
    }
}

extension AnyCancellable {
    func cancelled(to bag: CancelBag) {
        bag.append(self)
    }
}

//
//  Cancellable+Combine.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

extension Somari.Cancellable {
    var toCombine: Combine.Cancellable {
        return Combine.AnyCancellable {
            self.cancel()
        }
    }
}

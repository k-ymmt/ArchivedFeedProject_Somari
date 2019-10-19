//
//  Set+AnyCancellable.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

extension Set where Set.Element: AnyCancellable {
    public mutating func cancel() {
        for cancellable in self {
            cancellable.cancel()
        }

        self.removeAll()
    }
}

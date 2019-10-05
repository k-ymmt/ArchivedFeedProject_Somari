//
//  Set+AnyCancellable.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

extension Set where Set.Element: AnyCancellable {
    mutating func cancel() {
        for cancellable in self {
            cancellable.cancel()
        }
        
        self.removeAll()
    }
}

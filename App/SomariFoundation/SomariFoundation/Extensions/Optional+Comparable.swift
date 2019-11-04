//
//  Optional+Comparable.swift
//  SomariFoundation
//
//  Created by Kazuki Yamamoto on 2019/10/22.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Wrapped?, rhs: Wrapped?) -> Bool {
        guard lhs != rhs else {
            return true
        }

        guard let lhs = lhs else {
            return true
        }
        guard let rhs = rhs else {
            return false
        }
        return lhs < rhs
    }
}

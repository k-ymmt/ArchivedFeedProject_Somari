//
//  Gateway.swift
//  SomariFoundation
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

public protocol Gateway {
    associatedtype Input
    associatedtype Output
    associatedtype Dependency
    
    init(dependency: Dependency)
    
    func input(_ value: Input)
    func output(_ action: @escaping (Output) -> Void)
}

extension Gateway where Self.Dependency == Void {
    public init() {
        self.init(dependency: ())
    }
}

//
//  PropertyPublisher.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

@propertyWrapper
public class PropertyPublished<Value> {
    private let reactiveProperty: ReactiveProperty<Value>

    public var wrappedValue: PropertyPublisher<Value>

    public var value: Value {
        get { reactiveProperty.value }
        set { reactiveProperty.value = newValue }
    }

    public init(defaultValue: Value) {
        reactiveProperty = ReactiveProperty(defaultValue: defaultValue)
        wrappedValue = reactiveProperty.eraseToPropertyPublisher()
    }

    public func forceNotify() {
        reactiveProperty.forceNotify()
    }
}

public struct PropertyPublisher<Value>: Publisher {
    public typealias Output = Value
    public typealias Failure = Never

    private let property: ReactiveProperty<Value>

    public var value: Value {
        property.value
    }

    init(publisher: ReactiveProperty<Value>) {
        self.property = publisher
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        property.receive(subscriber: subscriber)
    }
}

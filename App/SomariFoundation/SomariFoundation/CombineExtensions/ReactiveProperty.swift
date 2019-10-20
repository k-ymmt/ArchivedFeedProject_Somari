//
//  ReactiveProperty.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

public class ReactiveProperty<Value>: Publisher {
    public typealias Output = Value
    public typealias Failure = Never

    private var subscribers: [CombineIdentifier: (Value) -> Void] = [:]
    private var locker: NSRecursiveLock = NSRecursiveLock()

    private let subject: CurrentValueSubject<Value, Never>

    public var value: Value {
        get { subject.value }
        set { subject.value = newValue }
    }

    public init(defaultValue: Value) {
        subject = CurrentValueSubject(defaultValue)
    }

    public func receiveValue(action: @escaping (Value) -> Void) -> AnyCancellable {
        subject.sink(receiveValue: action)
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }

    public func forceNotify() {
        subject.send(value)
    }
}

extension ReactiveProperty {
    public func eraseToPropertyPublisher() -> PropertyPublisher<Value> {
        return PropertyPublisher(publisher: self)
    }
}

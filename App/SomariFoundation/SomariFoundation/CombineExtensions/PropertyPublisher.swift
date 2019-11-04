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
public struct PropertyPublished<Value> {
    private let subject: CurrentValueSubject<Value, Never>

    public var wrappedValue: PropertyPublisher<Value>

    public var value: Value {
        get { subject.value }
        set { subject.send(newValue) }
    }

    public init(defaultValue: Value) {
        self.subject = CurrentValueSubject(defaultValue)
        wrappedValue = PropertyPublisher(subject: self.subject)
    }

    public func forceNotify() {
        subject.send(subject.value)
    }
}

public struct PropertyPublisher<Value>: Publisher {
    public typealias Output = Value
    public typealias Failure = Never

    private let subject: CurrentValueSubject<Value, Never>

    public var value: Value {
        subject.value
    }

    init(subject: CurrentValueSubject<Value, Never>) {
        self.subject = subject
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

extension PropertyPublisher {
    public func bind(to other: PropertyPublished<Value>) -> Combine.Cancellable {
        var other = other
        return self.sink { other.value = $0 }
    }
}

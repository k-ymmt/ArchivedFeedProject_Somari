//
//  EventPublisher.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

@propertyWrapper
public struct EventPublished<Value> {
    private let subject: PassthroughSubject<Value, Never>

    public var wrappedValue: EventPublisher<Value>

    public init() {
        subject = PassthroughSubject()
        wrappedValue = EventPublisher(subject: subject)
    }

    public func send(_ input: Value) {
        subject.send(input)
    }
}

public struct EventPublisher<Value>: Publisher {
    public typealias Output = Value
    public typealias Failure = Never

    private let subject: PassthroughSubject<Value, Never>

    public init(subject: PassthroughSubject<Value, Never>) {
        self.subject = subject
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

extension EventPublisher {
    public func bind(to other: EventPublished<Value>) -> Combine.Cancellable {
        self.sink { (value) in other.send(value) }
    }
}

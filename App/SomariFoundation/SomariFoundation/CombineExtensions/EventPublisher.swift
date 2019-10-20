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
public class EventPublished<Value> {
    private let subject: PassthroughSubject<Value, Never> = PassthroughSubject()

    public var wrappedValue: EventPublisher<Value>

    public init() {
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

//
//  ReactiveProperty.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Combine

@propertyWrapper
class Reactive<Value> {
    private let reactiveProperty: ReactiveProperty<Value>

    var wrappedValue: PropertyPublisher<Value> {
        reactiveProperty.eraseToPropertyPublisher()
    }
    
    var value: Value {
        get { reactiveProperty.value }
        set { reactiveProperty.value = newValue }
    }
    
    init(defaultValue: Value) {
        reactiveProperty = ReactiveProperty(defaultValue: defaultValue)
    }
    
    func forceNotify() {
        reactiveProperty.forceNotify()
    }
}

struct PropertyPublisher<Value>: Publisher {
    typealias Output = Value
    typealias Failure = Never
    
    private let property: ReactiveProperty<Value>
    
    var value: Value {
        property.value
    }
    
    init(publisher: ReactiveProperty<Value>) {
        self.property = publisher
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        property.receive(subscriber: subscriber)
    }
}

class ReactiveProperty<Value>: Publisher {
    typealias Output = Value
    typealias Failure = Never
    
    private var subscribers: [CombineIdentifier: (Value) -> Void] = [:]
    private var locker: NSRecursiveLock = NSRecursiveLock()
    
    private let subject: CurrentValueSubject<Value, Never>
    
    var value: Value {
        get { subject.value }
        set { subject.value = newValue }
    }
    
    init(defaultValue: Value) {
        subject = CurrentValueSubject(defaultValue)
    }
    
    func receiveValue(action: @escaping (Value) -> Void) -> AnyCancellable {
        subject.sink(receiveValue: action)
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
    
    func forceNotify() {
        subject.send(value)
    }
}

extension ReactiveProperty {
    func eraseToPropertyPublisher() -> PropertyPublisher<Value> {
        return PropertyPublisher(publisher: self)
    }
}

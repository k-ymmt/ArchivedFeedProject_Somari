//
//  UIButton+Combine.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import Combine

extension UIControl {
    func event(event: UIControl.Event) -> AnyPublisher<UIControl, Never> {
        let publisher = ControlPublisher(control: self, event: event)
        return publisher.eraseToAnyPublisher()
    }
}

class ControlSubscription<Control: UIControl>: Subscription {
    private let action: (Control) -> Void
    private let control: Control
    private let event: UIControl.Event
    
    init(control: Control, event: UIControl.Event, action: @escaping (Control) -> Void) {
        self.control = control
        self.event = event
        self.action = action
        
        control.addTarget(self, action: #selector(receiveEvent), for: event)
    }
    
    func request(_ demand: Subscribers.Demand) {
        
    }
    
    func cancel() {
        control.removeTarget(self, action: #selector(receiveEvent), for: event)
    }
    
    @objc func receiveEvent() {
        action(control)
    }
}

class ControlPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never
    
    let control: Control
    let event: UIControl.Event
    
    init(control: Control, event: UIControl.Event) {
        self.control = control
        self.event = event
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = ControlSubscription(control: control, event: event) { (control) in
            _ = subscriber.receive(control)
        }
        
        subscriber.receive(subscription: subscription)
    }
}

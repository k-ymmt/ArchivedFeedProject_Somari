//
//  UIView+Combine.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import Combine

extension UIView {
    public enum GestureEvent {
        case tap
    }

    public struct GestureOptions: OptionSet {
        public let rawValue: Int

        public static let cancelsTouchesInView = GestureOptions(rawValue: 1 << 0)

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    public func gesture(event: GestureEvent, options: UIView.GestureOptions? = nil) -> AnyPublisher<UIView, Never> {
        let publisher = GesturePublisher(view: self, event: event, options: options)

        return publisher.eraseToAnyPublisher()
    }
}

private class GestureSubscription<View: UIView>: Subscription {
    private let action: (View) -> Void
    private let view: View
    private var gesture: UIGestureRecognizer!

    init(view: View, event: UIView.GestureEvent, options: UIView.GestureOptions?, action: @escaping (View) -> Void) {
        self.view = view
        self.action = action

        switch event {
        case .tap:
            gesture = UITapGestureRecognizer(target: self, action: #selector(receiveEvent))
        }

        if let options = options {
            if options.contains(.cancelsTouchesInView) {
                gesture.cancelsTouchesInView = true
            }
        }

        view.addGestureRecognizer(gesture)
    }

    func request(_ demand: Subscribers.Demand) {
    }

    func cancel() {
        view.removeGestureRecognizer(gesture)
    }

    @objc func receiveEvent() {
        action(view)
    }
}

private class GesturePublisher<View: UIView>: Publisher {
    typealias Output = View
    typealias Failure = Never

    private let view: View
    private let event: UIView.GestureEvent
    private let options: UIView.GestureOptions?

    init(view: View, event: UIView.GestureEvent, options: UIView.GestureOptions? = nil) {
        self.view = view
        self.event = event
        self.options = options
    }

    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = GestureSubscription(view: view, event: event, options: options) { (view) in
            _ = subscriber.receive(view)
        }

        subscriber.receive(subscription: subscription)
    }
}

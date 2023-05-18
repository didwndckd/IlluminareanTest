//
//  UIControl+EventPublisher.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import UIKit
import Combine

extension UIControl {
    /// UIControl의 이벤트 방출을 위한 퍼블리셔
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(control: self.control, event: self.event, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension UIControl.EventPublisher {
    private final class EventSubscription<S: Subscriber>: Subscription where S.Input == UIControl, S.Failure == Never {
        private let control: UIControl
        private let event: UIControl.Event
        var subscriber: S?
        
        init(control: UIControl, event: UIControl.Event, subscriber: S) {
            self.control = control
            self.event = event
            self.subscriber = subscriber
            
            control.addTarget(self, action: #selector(Self.eventDidOccur), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            self.subscriber = nil
        }
        
        @objc
        private func eventDidOccur() {
            _ = self.subscriber?.receive(control)
        }
    }
}

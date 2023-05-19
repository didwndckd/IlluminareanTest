//
//  SubscribeCountTracker.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation
import Combine

final class SubscribeCountTracker: Publisher {
    typealias Output = Int
    typealias Failure = Never
    
    private let lock = NSRecursiveLock()
    private let countSubject = CurrentValueSubject<Int, Never>(0)
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        self.countSubject
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .subscribe(subscriber)
    }
    
    fileprivate func increment() {
        self.lock.lock()
        self.countSubject.send(self.countSubject.value + 1)
        self.lock.unlock()
    }
    
    fileprivate func decrement() {
        self.lock.lock()
        self.countSubject.send(self.countSubject.value - 1)
        self.lock.unlock()
    }
}

extension SubscribeCountTracker {
    var value: Int {
        return self.countSubject.value
    }
}

extension Publisher {
    func trackCount(_ tracker: SubscribeCountTracker) -> AnyPublisher<Output, Failure> {
        return self.handleEvents(
            receiveCompletion: { completion in
                tracker.decrement()
            },
            receiveCancel: {
                tracker.decrement()
            },
            receiveRequest: { _ in
                tracker.increment()
            })
        .eraseToAnyPublisher()
    }
}

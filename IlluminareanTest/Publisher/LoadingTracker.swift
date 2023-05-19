//
//  LoadingTracker.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation
import Combine

final class LoadingTracker: Publisher {
    typealias Output = Bool
    typealias Failure = Never
    
    fileprivate let countTracker = SubscribeCountTracker()
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Bool == S.Input {
        self.countTracker
            .map { $0 > 0 }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .subscribe(subscriber)
    }
}

extension LoadingTracker {
    var value: Bool {
        return self.countTracker.value > 0
    }
}

extension Publisher {
    func trackLoading(_ tracker: LoadingTracker) -> AnyPublisher<Output, Failure> {
        return self.trackCount(tracker.countTracker)
    }
}

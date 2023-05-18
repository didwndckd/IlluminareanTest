//
//  Publisher+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation
import Combine

extension Publisher {
    /// 전달받은 객체 약한참조 하여 다음 스트림으로 넘겨주는 변환 함수
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        return self.compactMap { [weak object] output in
            guard let object = object else { return nil }
            return (object, output)
        }
    }
    
    /// 전달받은 객체 약한참조 하여 sink
    func sink<T: AnyObject>(with object: T, receiveCompletion: ((T, Subscribers.Completion<Self.Failure>) -> Void)? = nil, receiveValue: ((T, Self.Output) -> Void)? = nil) -> AnyCancellable {
        return self.sink(
            receiveCompletion: { [weak object] completion in
                guard let object = object else { return }
                receiveCompletion?(object, completion)
            }, receiveValue: { [weak object] value in
                guard let object = object else { return }
                receiveValue?(object, value)
            })
    }
}

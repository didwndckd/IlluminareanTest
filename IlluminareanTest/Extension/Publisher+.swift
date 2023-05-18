//
//  Publisher+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation
import Combine

extension Publisher {
    /// weak self를 적용하여 다음 스트림으로 넘겨주는 변환 함수
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        return self.compactMap { [weak object] output in
            guard let object = object else { return nil }
            return (object, output)
        }
    }
}

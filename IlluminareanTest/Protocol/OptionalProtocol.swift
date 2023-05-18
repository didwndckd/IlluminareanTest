//
//  OptionalProtocol.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation

protocol OptionalProtocol {
    var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
    var isNil: Bool {
        return self == nil
    }
}

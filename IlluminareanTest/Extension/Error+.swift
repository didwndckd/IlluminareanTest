//
//  Error+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/20.
//

import Foundation

extension Error {
    var message: String {
        return (self as? APIError)?.message ?? self.localizedDescription
    }
    
    var code: Int {
        return (self as NSError).code
    }
}

//
//  LoginService.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation

final class LoginService {
    static let shared = LoginService()
    private init() {}
    
}

// MARK: interface
extension LoginService {
    var isLogin: Bool {
        return false
    }
}

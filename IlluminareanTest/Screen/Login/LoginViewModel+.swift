//
//  LoginViewModel+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/17.
//

import Foundation
import Combine

extension LoginViewModel {
    struct Input {
        let lgoin: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let alert: AnyPublisher<SystemAlert, Never>
        let moveTo: AnyPublisher<MoveTo, Never>
    }
    
    enum MoveTo {
        case searchUser
    }
}

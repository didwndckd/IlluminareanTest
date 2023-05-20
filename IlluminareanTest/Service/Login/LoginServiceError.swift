//
//  LoginServiceError.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation

enum LoginServiceError: Error {
    case canNotOpenGithub
    case noCode
    case networkFailure(APIError)
}

extension LoginServiceError {
    var message: String {
        switch self {
        case .networkFailure(let origin):
            return origin.message
        default:
            return "오류가 발생하였습니다"
        }
    }
}

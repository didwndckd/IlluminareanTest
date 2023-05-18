//
//  APIError.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation
import Moya

enum APIError: Error {
    case connectionFailure
    case cancelled
    case parsingFailure(originError: Error, originData: Data)
    case unknown(origin: Error)
}

extension APIError {
    init(moyaError: MoyaError) {
        if moyaError.code == -1009 || moyaError.code == -1020 {
            self = .connectionFailure
        }
        else if moyaError.code == 6 {
            self = .cancelled
        }
        else {
            self = .unknown(origin: moyaError)
        }
    }
    
    var code: Int {
        switch self {
        case .connectionFailure:
            return 1
        case .cancelled:
            return 2
        case .parsingFailure:
            return 3
        case .unknown:
            return 4
        }
    }
    
    var codeDescription: String {
        switch self {
        case .connectionFailure, .cancelled:
            return "\(self.code)"
        case .parsingFailure(originError: let origin, originData: _):
            return "\(self.code)-\(origin.code)"
        case .unknown(origin: let origin):
            return "\(self.code)-\(origin.code)"
        }
    }
    
    var rawMessage: String {
        switch self {
        case .connectionFailure:
            return "네트워크 연결을 확인해 주세요"
        case .cancelled:
            return "요청이 취소되었습니다"
        case .parsingFailure:
            return "오류가 발생하였습니다"
        case .unknown:
            return "네트워크 오류가 발생하였습니다"
        }
    }
    
    var message: String {
        return self.rawMessage + "[\(self.codeDescription)]"
    }
    
    var isNetworkConnectionFailureError: Bool {
        switch self {
        case .connectionFailure: return true
        default: return false
        }
    }
    
    var isCancelled: Bool {
        switch self {
        case .cancelled: return true
        default: return false
        }
    }
    
    func log() {
        switch self {
        case .connectionFailure:
            print("APIError: 네트워크 연결 에러")
        case .cancelled:
            print("APIError: 요청 취소")
        case .parsingFailure(originError: let error, originData: _):
            print("APIError: 파싱 에러 -> \(error)")
        case .unknown(origin: let error):
            print("APIError: 알수없는 네트워크 에러 -> \(error)")
        }
    }
}

extension Error {
    var message: String {
        return (self as? APIError)?.message ?? self.localizedDescription
    }
    
    var code: Int {
        if let apiError = self as? APIError {
            return apiError.code
        }
        else if let error = self.asAFError?.underlyingError {
            let code = (error as NSError).code
            return code
        }
        else {
            let code = (self as NSError).code
            return code
        }
    }
}

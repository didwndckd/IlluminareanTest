//
//  APITarget+GitHub.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation
import Moya

extension APITarget {
    enum GitHub {
        case accessToken(code: String)
    }
}

extension APITarget.GitHub: APITargetType {
    var baseURL: URL {
        return URL(string: Constant.Domain.gitHub)!
    }
    
    var path: String {
        switch self {
        case .accessToken:
            return "login/oauth/access_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .accessToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .accessToken(code: let code):
            let parameters = ["client_id": Constant.Secret.gitHubClientId,
                              "client_secret": Constant.Secret.gitHubClientSecret,
                              "code": code]
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .accessToken:
            return ["Accept": "application/json"]
        }
    }
    
    
}

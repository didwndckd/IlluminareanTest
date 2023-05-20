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
        case searchUsers(query: String, page: Int, perPage: Int)
    }
}

extension APITarget.GitHub: APITargetType {
    var baseURL: URL {
        switch self {
        case .accessToken:
            return URL(string: Constant.Domain.gitHub)!
        case .searchUsers:
            return URL(string: Constant.Domain.gitHubApi)!
        }
        
    }
    
    var path: String {
        switch self {
        case .accessToken:
            return "login/oauth/access_token"
        case .searchUsers:
            return "search/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .accessToken:
            return .post
        case .searchUsers:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .accessToken(code: let code):
            let parameters = ["client_id": Constant.Secret.gitHubClientId,
                              "client_secret": Constant.Secret.gitHubClientSecret,
                              "code": code]
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .searchUsers(query: let query, page: let page, perPage: let perPage):
            let parameters: [String: Any] = ["q": query,
                              "page": page,
                              "per_page": perPage]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .accessToken:
            return ["Accept": "application/json"]
        case .searchUsers:
            guard let tokenData = LoginService.shared.accessTokenData else { return nil }
            return ["Authorization": "\(tokenData.tokenType) \(tokenData.accessToken)"]
        }
    }
    
    
}

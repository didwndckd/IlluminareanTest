//
//  APILoggerPlugin.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation
import Moya

struct APILoggerPlugin: PluginType {
    #if DEBUG
    func willSend(_ request: RequestType, target: Moya.TargetType) {
        guard let request = request.request else { return }
        let prefix = "Network Request -> "
        
        print("\n======== \(prefix) Log Start ========")
        print("\(prefix)URL:", request.url?.absoluteString.removingPercentEncoding ?? "nil")
        print("\(prefix)Method:", request.httpMethod ?? "nil")
        print("\(prefix)Header:", request.allHTTPHeaderFields ?? "nil")
        var bodyDescription = "nil"
        if let bodyData = request.httpBody {
            bodyDescription = String(data: bodyData, encoding: .utf8)?.removingPercentEncoding ?? "nil"
        }
        print("\(prefix)Body:", bodyDescription)
        print("======== \(prefix) Log End ========\n")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: Moya.TargetType) {
        let prefix = "Network Response -> "
        
        print("\n======== \(prefix) Log Start ========")
        
        switch result {
        case .success(let response):
            print("\(prefix)Success 😁")
            print("\(prefix)URL:", response.response?.url ?? "nil")
            print("\(prefix)Header:", response.response?.allHeaderFields ?? "nil")
            let resultLog = String(data: response.data, encoding: .utf8) ?? "nil"
            print("\(prefix)Data:", resultLog)
        case .failure(let error):
            print("\(prefix)Failure 🐛")
            print("\(prefix)URL:", target.baseURL.appendingPathComponent(target.path).absoluteString.removingPercentEncoding ?? "nil")
            print("\(prefix)Error:", error.errorCode)
            print("\(prefix)Error:", error.localizedDescription)
        }
        print("======== \(prefix) Log End ========\n")
    }
    #endif
}

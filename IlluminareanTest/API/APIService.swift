//
//  APIService.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation
import Combine
import Moya

final class APIService {
    func request<T: APITargetType, P: Decodable>(_ target: T, plugins: [PluginType] = [], parsingType: P.Type) -> some Publisher<P, APIError> {
        let provider = APIProvider<T>(plugins: plugins)
        
        return provider.request(target)
            .flatMap({ response in
                let data = response.data
                do {
                    let result = try JSONDecoder().decode(P.self, from: data)
                    
                    return Result<P, APIError>.Publisher(.success(result))
                } catch let error {
                    let error = APIError.parsingFailure(originError: error, originData: data)
                    
                    return Result<P, APIError>.Publisher(.failure(error))
                }
            })
    }
}

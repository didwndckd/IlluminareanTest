//
//  APIProvider.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class APIProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ target: T, callbackQueue: DispatchQueue? = nil) -> AnyPublisher<Response, APIError> {
        return self.requestPublisher(target, callbackQueue: callbackQueue)
            .mapError { APIError(moyaError: $0) }
            .handleEvents(receiveCompletion: { _ in let _ = self })
            .eraseToAnyPublisher()
    }
}

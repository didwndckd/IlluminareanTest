//
//  KeyChainStorage.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import Foundation
import KeychainSwift

/// 키체인 편의 저장을 위한 propertyWrapper
@propertyWrapper
struct KeyChainStorage<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let keyChain = KeychainSwift()
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let dataString = self.keyChain.get(self.key),
                  let data = dataString.data(using: .utf8),
                  let result = try? JSONDecoder().decode(T.self, from: data) else {
                return self.defaultValue
            }
            
            return result
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil {
                self.keyChain.delete(self.key)
                return
            }
            
            guard let data = try? JSONEncoder().encode(newValue),
                  let dataString = String(data: data, encoding: .utf8) else {
                return
            }
            
            self.keyChain.set(dataString, forKey: self.key)
        }
    }
}

//
//  SearchUserViewModel+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation
import Combine

extension SearchUserViewModel {
    struct Input {
        let searchKeyword: AnyPublisher<String, Never>
        let search: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let searchKeywordIsEmpty: AnyPublisher<Bool, Never>
    }
}
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
        let logout: AnyPublisher<Void, Never>
        let searchKeyword: AnyPublisher<String, Never>
        let search: AnyPublisher<Void, Never>
        let nextPage: AnyPublisher<Void, Never>
        let selectedIndex: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let alert: AnyPublisher<SystemAlert, Never>
        let moveTo: AnyPublisher<MoveTo, Never>
        let loading: AnyPublisher<Bool, Never>
        let searchKeywordIsEmpty: AnyPublisher<Bool, Never>
        let reload: AnyPublisher<Void, Never>
        let isNoSearchResult: AnyPublisher<Bool, Never>
    }
    
    enum MoveTo {
        case login
        case safari(URL)
    }
}

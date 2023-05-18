//
//  SearchUserViewModel.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation
import Combine

final class SearchUserViewModel: ViewModel {
    private var cancelBag: Set<AnyCancellable> = []
    private let searchKeyword = CurrentValueSubject<String, Never>("")
}

extension SearchUserViewModel {
    func transform(input: Input) -> Output {
        input.searchKeyword
            .sink(with: self, receiveValue: { viewModel, keyword in
                viewModel.searchKeyword.send(keyword)
            })
            .store(in: &self.cancelBag)
        
        input.search
            .sink(with: self, receiveValue: { viewModel, _ in
                print("search")
            })
            .store(in: &self.cancelBag)
        
        return Output(searchKeywordIsEmpty: self.searchKeyword.map { $0.isEmpty }.eraseToAnyPublisher())
    }
}

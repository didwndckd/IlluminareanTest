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
    private let alert = PassthroughSubject<SystemAlert, Never>()
    private let moveTo = PassthroughSubject<MoveTo, Never>()
    private let loading = LoadingTracker()
    private let nextPageLoading = LoadingTracker()
    private let searchKeyword = CurrentValueSubject<String, Never>("")
    private let users = CurrentValueSubject<[GitHubUser], Never>([])
    private let apiService = APIService()
    private let perPage = 30
    private var totalCount = 0
    private var currentPage = 1
}

// MARK: private
extension SearchUserViewModel {
    /// 키워드 검색
    private func searchUsers() {
        self.users.send([])
        
        self.searchUserRequest(query: self.searchKeyword.value, page: 1, perPage: self.perPage)
            .trackLoading(self.loading)
            .sink(
                with: self,
                receiveCompletion: { viewModel, completion in
                    switch completion {
                    case .failure(let error):
                        let alert = SystemAlert(title: "오류", message: error.message)
                        viewModel.alert.send(alert)
                    case .finished:
                        break
                    }
                },
                receiveValue: { viewModel, response in
                    viewModel.currentPage = 1
                    viewModel.totalCount = response.totalCount
                    viewModel.users.send(response.users)
                })
            .store(in: &self.cancelBag)
    }
    
    /// 다음 페이지
    private func searchNextPage() {
        let nextPage = self.currentPage + 1
        guard !self.loading.value && !self.nextPageLoading.value && self.numberOfUsers < self.totalCount else {
            return
        }
        
        self.searchUserRequest(query: self.searchKeyword.value, page: nextPage, perPage: self.perPage)
            .trackLoading(self.nextPageLoading)
            .sink(
                with: self,
                receiveValue: { viewModel, response in
                    viewModel.currentPage = nextPage
                    viewModel.totalCount = response.totalCount
                    let latestUsers = viewModel.users.value
                    viewModel.users.send(latestUsers + response.users)
                })
            .store(in: &self.cancelBag)
    }
    
    /// 유저 선택
    private func selectedUser(index: Int) {
        let user = self.user(index: index)
        guard let url = URL(string: user.gitHubPageUrl) else { return }
        self.moveTo.send(.safari(url))
    }
    
}

// MARK: API
extension SearchUserViewModel {
    /// 유저 검색 리퀘스트 퍼블리셔
    private func searchUserRequest(query: String, page: Int, perPage: Int) -> some Publisher<GitHubUserList, APIError> {
        let target = APITarget.GitHub.searchUsers(query: query, page: page, perPage: perPage)
        return self.apiService.request(target, plugins: [APILoggerPlugin()], parsingType: GitHubUserList.self)
    }
}

// MARK: transform
extension SearchUserViewModel {
    func transform(input: Input) -> Output {
        input.logout
            .sink(with: self, receiveValue: { viewModel, _ in
                LoginService.shared.logout()
                viewModel.moveTo.send(.login)
            })
            .store(in: &self.cancelBag)
        
        input.searchKeyword
            .sink(with: self, receiveValue: { viewModel, keyword in
                viewModel.searchKeyword.send(keyword)
            })
            .store(in: &self.cancelBag)
        
        input.search
            .sink(with: self, receiveValue: { viewModel, _ in
                viewModel.searchUsers()
            })
            .store(in: &self.cancelBag)
        
        input.nextPage
            .sink(with: self, receiveValue: { viewModel, _ in
                viewModel.searchNextPage()
            })
            .store(in: &self.cancelBag)
        
        input.selectedIndex
            .sink(with: self, receiveValue: { viewModel, index in
                viewModel.selectedUser(index: index)
            })
            .store(in: &self.cancelBag)
        
        let isNoSearchResult = self.users.combineLatest(self.loading)
            .map { users, isLoading in
                return users.isEmpty && !isLoading
            }
        
        return Output(alert: self.alert.eraseToAnyPublisher(),
                      moveTo: self.moveTo.eraseToAnyPublisher(),
                      loading: self.loading.eraseToAnyPublisher(),
                      searchKeywordIsEmpty: self.searchKeyword.map { $0.isEmpty }.eraseToAnyPublisher(),
                      reload: self.users.map { _ in () }.eraseToAnyPublisher(),
                      isNoSearchResult: isNoSearchResult.eraseToAnyPublisher())
    }
}

// MARK: interface
extension SearchUserViewModel {
    var numberOfUsers: Int {
        return self.users.value.count
    }
    
    func user(index: Int) -> GitHubUser {
        return self.users.value[index]
    }
    
    func isLast(index: Int) -> Bool {
        let lastIndex = self.numberOfUsers - 1
        return lastIndex == index
    }
}

//
//  LoginViewModel.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/17.
//

import Foundation
import Combine

final class LoginViewModel: ViewModel {
    private var cancelBag: Set<AnyCancellable> = []
    private let alert = PassthroughSubject<SystemAlert, Never>()
    private let moveTo = PassthroughSubject<MoveTo, Never>()
}

// MARK: private functions
extension LoginViewModel {
    private func login() {
        LoginService.shared.login()
            .sink(
                with: self,
                receiveCompletion: { viewModel, completion in
                    switch completion {
                    case .failure(let error):
                        let alert = SystemAlert(title: "알림", message: error.message)
                        viewModel.alert.send(alert)
                    case .finished:
                        break
                    }
                },
                receiveValue: { viewModel, result in
                    viewModel.moveTo.send(.searchUser)
                })
            .store(in: &self.cancelBag)
    }
}

// MARK: transform
extension LoginViewModel {
    func transform(input: Input) -> Output {
        input.lgoin
            .withUnretained(self)
            .sink(receiveValue: { viewModel, _ in
                viewModel.login()
            })
            .store(in: &self.cancelBag)
        
        return Output(alert: self.alert.eraseToAnyPublisher(),
                      moveTo: self.moveTo.eraseToAnyPublisher())
    }
}

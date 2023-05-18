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
}

// MARK: private functions
extension LoginViewModel {
    private func login() {
        LoginService.shared.login()
            .sink(
                receiveCompletion: { completion in
                    print(completion)
                },
                receiveValue: { print($0) })
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
        
        return Output()
    }
}

//
//  LoginService.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import UIKit
import Combine
import KeychainSwift

enum LoginServiceError: Error {
    case canNotOpenGithub
    case noCode
    case networkFailure(APIError)
}

final class LoginService {
    static let shared = LoginService()
    private init() {}
    
    private var cancelBag: Set<AnyCancellable> = []
    private var loginResult = PassthroughSubject<GitHubAccessToken, LoginServiceError>()
    
    @KeyChainStorage(key: Constant.Key.accessToken, defaultValue: nil)
    private var storedAccessToken: GitHubAccessToken?
    
    private let apiService = APIService()
    
}

extension LoginService {
    /// 깃헙에 코드를 요청하고 실패시 loginResult에 에러 방출
    private func requestGithubCode() {
        guard let url = URL(string: Constant.Domain.gitHub + "/login/oauth/authorize?client_id=\(Constant.Secret.gitHubClientId)&scope=repo,user") else {
            self.loginResult.send(completion: .failure(.canNotOpenGithub))
            return
        }
        
        UIApplication.shared.open(url) { [weak self] result in
            if !result {
                self?.loginResult.send(completion: .failure(.canNotOpenGithub))
            }
        }
    }
    
    /// 깃헙에 AccessToken 요청 후 결과 방출
    private func requestAccessToken(code: String) {
        let target = APITarget.GitHub.accessToken(code: code)
        self.apiService.request(target, parsingType: GitHubAccessToken.self)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.loginResult.send(completion: .failure(.networkFailure(error)))
                    case .finished:
                        self?.loginResult.send(completion: .finished)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.storedAccessToken = response
                    self?.loginResult.send(response)
                })
            .store(in: &self.cancelBag)
    }
}

// MARK: interface
extension LoginService {
    /// 로그인 여부
    var isLogin: Bool {
        return self.storedAccessToken != nil
    }
    
    /// 토큰 데이터
    var accessToken: GitHubAccessToken? {
        return self.storedAccessToken
    }
    
    /// 로그인 요청 후 결과 퍼블리셔 반환
    func login() -> some Publisher<GitHubAccessToken, LoginServiceError> {
        self.loginResult = .init()
        self.requestGithubCode()
        return self.loginResult
    }
    
    /// 외부 링크로 들어왔을때 code를 뽑아서 액세스 토큰 요청
    func receiveCode(url: URL) {
        guard
            let component = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let code = component.queryItems?.first(where: { $0.name == "code" })?.value,
            !code.isEmpty
        else {
            self.loginResult.send(completion: .failure(.noCode))
            return
        }
        
        self.requestAccessToken(code: code)
    }
}

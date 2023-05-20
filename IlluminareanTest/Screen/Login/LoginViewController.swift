//
//  LoginViewController.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/17.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    private var cancelBag: Set<AnyCancellable> = []
    private let viewModel: LoginViewModel
    
    // MARK: UI property
    private let loginButton = UIButton(type: .system).then { button in
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .label
        button.layer.cornerRadius = 8
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAttribute()
        self.setupLayout()
        self.bindUI()
    }
    
    private func setupAttribute() {
        self.view.backgroundColor = .systemBackground
        self.title = "로그인"
    }
    
    private func setupLayout() {
        self.view.addSubviews(self.loginButton)
        
        self.loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
}

// MARK: bindUI
extension LoginViewController {
    private func bindUI() {
        let input = LoginViewModel.Input(lgoin: self.loginButton.eventPublisher(for: .touchUpInside).map { _ in () }.eraseToAnyPublisher())
        let output = self.viewModel.transform(input: input)
        
        output.moveTo
            .receive(on: DispatchQueue.main)
            .sink(
                with: self,
                receiveValue: { controller, moveTo in
                    switch moveTo {
                    case .searchUser:
                        controller.replaceSearchUser()
                    }
                })
            .store(in: &self.cancelBag)
    }
}

// MARK: MoveTo
extension LoginViewController {
    private func replaceSearchUser() {
        let viewModel = SearchUserViewModel()
        let viewController = SearchUserViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        WindowService.shared.replaceRootViewController(navigationController, animated: true)
    }
}

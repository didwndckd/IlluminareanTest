//
//  LoginViewController.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/17.
//

import UIKit

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    
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
    }
    
    private func setupAttribute() {
        self.title = "로그인"
    }
    
    private func setupLayout() {
        
    }
}

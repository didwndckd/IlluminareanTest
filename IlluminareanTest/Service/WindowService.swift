//
//  WindowService.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import UIKit

final class WindowService {
    static let shared = WindowService()
    private init() {}
    
    var window: UIWindow?
}

extension WindowService {
    func configure(window: UIWindow) {
        if LoginService.shared.isLogin {
            
        }
        else {
            let viewModel = LoginViewModel()
            let viewController = LoginViewController(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navigationController
        }
        
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func replaceRootViewController(_ viewController: UIViewController, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard let window = self.window else { return }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        guard animated else {
            completion?(false)
            return
        }
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: completion)
    }
}

//
//  UIViewController+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import UIKit

extension UIViewController {
    /// SystemAlert 기반으로 UIAlertController를 띄우는 함수
    func presentAlert(_ model: SystemAlert) {
        let alertController = UIAlertController(model: model)
        self.present(alertController, animated: true)
    }
}

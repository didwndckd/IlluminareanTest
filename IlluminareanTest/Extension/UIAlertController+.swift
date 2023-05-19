//
//  UIAlertController+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import UIKit

extension UIAlertController {
    /// SystemAlertl을 사용하여 UIAlertController를 생성하기 위한 편의 생성자
    convenience init(model alert: SystemAlert) {
        let style: UIAlertController.Style
        switch alert.style {
        case .alert:
            style = .alert
        case .actionSheet:
            style = .actionSheet
        }
        
        self.init(title: alert.title, message: alert.message, preferredStyle: style)
        self.setupActions(alert.actions)
    }
    
    /// SystemAlertAction배열을 받아 자신의 액션에 추가
    private func setupActions(_ actions: [SystemAlertAction]) {
        actions.map { action -> UIAlertAction in
            return UIAlertAction(title: action.title,
                                 style: .init(rawValue: action.style.rawValue) ?? .default,
                                 handler: { _ in action.handler?() })
        }
        .forEach { action in
            self.addAction(action)
        }
    }
}

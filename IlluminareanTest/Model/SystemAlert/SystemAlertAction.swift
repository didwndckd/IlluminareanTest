//
//  SystemAlertAction.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation

/// SystemAlertModel에서 사용할 액션 모델
struct SystemAlertAction {
    let title: String
    let style: Style
    let handler: (() -> Void)?
    
    init(title: String, style: Style = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension SystemAlertAction {
    enum Style: Int {
        case `default` = 0
        case cancel = 1
        case destructive = 2
    }
}

//
//  SystemAlert.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation

/// 뷰모델에서 방출하기 위한 시스템 Alert 모델
struct SystemAlert {
    let title: String?
    let message: String?
    let style: Style
    let actions: [SystemAlertAction]
    
    init(title: String? = nil, message: String? = nil, style: Style = .alert, actions: [SystemAlertAction]) {
        self.title = title
        self.message = message
        self.style = style
        self.actions = actions
    }
}

extension SystemAlert {
    enum Style {
        case alert
        case actionSheet
    }
}

extension SystemAlert {
    init(title: String? = nil,
         message: String? = nil,
         okTitle: String = "확인") {
        self.title = title
        self.message = message
        self.style = .alert
        self.actions = [SystemAlertAction(title: okTitle, handler: nil)]
    }
    
    init(title: String? = nil,
         message: String? = nil,
         okTitle: String = "확인",
         okAction: (() -> Void)?) {
        self.title = title
        self.message = message
        self.style = .alert
        self.actions = [SystemAlertAction(title: okTitle, handler: okAction)]
    }
    
    init(title: String? = nil,
         message: String? = nil,
         okTitle: String = "확인",
         okAction: (() -> Void)?,
         cancelTitle: String = "취소",
         cancelAction: (() -> Void)?) {
        self.title = title
        self.message = message
        self.style = .alert
        self.actions = [SystemAlertAction(title: okTitle, handler: okAction),
                        SystemAlertAction(title: cancelTitle, style: .cancel, handler: cancelAction)]
    }
}


//
//  UIControl+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import UIKit
import Combine

extension UIControl {
    func eventPublisher(for event: Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
    }
}

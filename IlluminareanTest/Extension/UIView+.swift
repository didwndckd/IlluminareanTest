//
//  UIView+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/18.
//

import UIKit
import SnapKit
import Then

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}

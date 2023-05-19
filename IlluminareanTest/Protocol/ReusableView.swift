//
//  ReusableView.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation

protocol ReusableView {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

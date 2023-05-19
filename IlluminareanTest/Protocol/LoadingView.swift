//
//  LoadingView.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation

protocol LoadingView: AnyObject {
    func startLoading()
    func stopLoading()
}

extension LoadingView {
    func startLoading(completion: (() -> Void)?) {
        self.startLoading()
        completion?()
    }
    
    func stopLoading(completion: (() -> Void)?) {
        self.stopLoading()
        completion?()
    }
}

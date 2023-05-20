//
//  UIActivityIndicatorView+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import UIKit

extension UIActivityIndicatorView: LoadingView {
    func startLoading() {
        self.startAnimating()
    }
    
    func stopLoading() {
        self.stopAnimating()
    }
}

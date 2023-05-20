//
//  UIImageView+.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ url: URL?, placeholder: UIImage? = nil) {
        self.kf.setImage(with: url, placeholder: placeholder)
    }
    
    func setImage(_ urlString: String, placeholder: UIImage? = nil) {
        self.setImage(URL(string: urlString), placeholder: placeholder)
    }
}


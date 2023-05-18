//
//  SearchUserViewController.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import UIKit
import Combine

final class SearchUserViewController: UIViewController {
    private var cancelBag: Set<AnyCancellable> = []
    private let viewModel: SearchUserViewModel
    
    init(viewModel: SearchUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAttribute()
        self.setupLayout()
    }
    
    private func setupAttribute() {
        self.title = "검색"
    }
    
    private func setupLayout() {
        
    }
}

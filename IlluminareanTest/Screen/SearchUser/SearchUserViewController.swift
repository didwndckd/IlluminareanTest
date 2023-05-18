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
    private let searchKeyword = PassthroughSubject<String, Never>()
    private let search = PassthroughSubject<Void, Never>()
    
    private let searchContainerView = UIView().then { view in
        view.backgroundColor = .secondarySystemFill
        view.layer.cornerRadius = 8
    }
    
    private let searchContentStackView = UIStackView().then { view in
        view.spacing = 8
    }
    
    private let searchBarLeftImageView = UIImageView().then { view in
        view.image = UIImage(systemName: "magnifyingglass")
        view.contentMode = .scaleAspectFit
        view.tintColor = .secondaryLabel
    }
    
    private let clearButton = UIButton(type: .system).then { view in
        view.setImage(UIImage(systemName: "delete.left"), for: .normal)
        view.tintColor = .secondaryLabel
        view.isHidden = true
    }
    
    private let textField = UITextField().then { view in
        view.placeholder = "유저 검색"
        view.returnKeyType = .search
    }
    
    private let tableView = UITableView().then { view in
        
    }
    
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
        self.bindUI()
    }
    
    private func setupAttribute() {
        self.view.backgroundColor = .systemBackground
        self.title = "검색"
        
        self.textField.delegate = self
        
        self.textField.eventPublisher(for: .editingChanged)
            .withUnretained(self.textField)
            .map { textField, _ in
                return textField.text ?? ""
            }
            .sink(with: self, receiveValue: { controller, text in
                controller.searchKeyword.send(text)
            })
            .store(in: &self.cancelBag)
        
        self.clearButton.eventPublisher(for: .touchUpInside)
            .sink(with: self, receiveValue: { controller, _ in
                controller.textField.text = ""
                controller.searchKeyword.send("")
            })
            .store(in: &self.cancelBag)
    }
    
    private func setupLayout() {
        self.view.addSubviews(self.searchContainerView, self.tableView)
        
        self.searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchContainerView.snp.bottom)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview()
        }
        
        // 검색창
        self.searchContainerView.addSubview(self.searchContentStackView)
        
        self.searchContentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
        }
        
        [self.searchBarLeftImageView, self.textField, self.clearButton].forEach { view in
            self.searchContentStackView.addArrangedSubview(view)
        }
        
        self.searchBarLeftImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
    }
}

// MARK: bindUI
extension SearchUserViewController {
    private func bindUI() {
        let input = SearchUserViewModel.Input(searchKeyword: self.searchKeyword.eraseToAnyPublisher(),
                                              search: self.search.eraseToAnyPublisher())
        let output = self.viewModel.transform(input: input)
        
        output.searchKeywordIsEmpty
            .sink(with: self, receiveValue: { controller, isEmpty in
                controller.clearButton.isHidden = isEmpty
            })
            .store(in: &self.cancelBag)
    }
}

// MARK: UITextFieldDelegate
extension SearchUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let result = !(textField.text ?? "").isEmpty
        if result {
            textField.endEditing(true)
            self.search.send(())
        }
        return result
    }
}

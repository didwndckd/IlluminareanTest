//
//  SearchUserViewController.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import UIKit
import Combine
import SafariServices

final class SearchUserViewController: UIViewController, Loadable {
    private var cancelBag: Set<AnyCancellable> = []
    private let viewModel: SearchUserViewModel
    private let logout = PassthroughSubject<Void, Never>()
    private let searchKeyword = PassthroughSubject<String, Never>()
    private let search = PassthroughSubject<Void, Never>()
    private let nextPage =  PassthroughSubject<Void, Never>()
    private let selectedIndex =  PassthroughSubject<Int, Never>()
    
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
        view.setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        view.tintColor = .secondaryLabel
        view.isHidden = true
    }
    
    private let textField = UITextField().then { view in
        view.placeholder = "유저 검색"
        view.returnKeyType = .search
    }
    
    private let tableView = UITableView().then { view in
        view.register(GitHubUserCell.self)
        view.keyboardDismissMode = .onDrag
    }
    
    private let noSearchResultLabel = UILabel().then { view in
        view.text = "검색 결과가 없습니다."
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.textAlignment = .center
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
        self.setupNaigationBar()
        self.setupAttribute()
        self.setupLayout()
        self.setupActions()
        self.bindUI()
    }
    
    private func setupNaigationBar() {
        self.title = "검색"
        
        let logoutAction = UIAction() { [weak self] _ in
            self?.logout.send(())
        }
        
        let logoutButton = UIBarButtonItem(title: "로그아웃", primaryAction: logoutAction)
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    private func setupAttribute() {
        self.view.backgroundColor = .systemBackground
        
        self.textField.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setupLayout() {
        self.view.addSubviews(self.searchContainerView, self.tableView, self.noSearchResultLabel)
        
        self.searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchContainerView.snp.bottom)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        self.noSearchResultLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.centerY.equalToSuperview()
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
            make.width.equalTo(20)
        }
    }
    
    private func setupActions() {
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
}

// MARK: bindUI
extension SearchUserViewController {
    private func bindUI() {
        let input = SearchUserViewModel.Input(logout: self.logout.eraseToAnyPublisher(),
                                              searchKeyword: self.searchKeyword.eraseToAnyPublisher(),
                                              search: self.search.eraseToAnyPublisher(),
                                              nextPage: self.nextPage.eraseToAnyPublisher(),
                                              selectedIndex: self.selectedIndex.eraseToAnyPublisher())
        let output = self.viewModel.transform(input: input)
        
        output.alert
            .receive(on: DispatchQueue.main)
            .sink(with: self, receiveValue: { controller, alert in
                controller.presentAlert(alert)
            })
            .store(in: &self.cancelBag)
        
        output.moveTo
            .receive(on: DispatchQueue.main)
            .sink(with: self, receiveValue: { controller, moveTo in
                switch moveTo {
                case .login:
                    controller.replaceLogin()
                case .safari(let url):
                    controller.presentSafari(url: url)
                }
            })
            .store(in: &self.cancelBag)
        
        output.loading
            .receive(on: DispatchQueue.main)
            .sink(with: self, receiveValue: { controller, isLoading in
                controller.loading(isLoading)
            })
            .store(in: &self.cancelBag)
        
        output.searchKeywordIsEmpty
            .receive(on: DispatchQueue.main)
            .sink(with: self, receiveValue: { controller, isEmpty in
                controller.clearButton.isHidden = isEmpty
            })
            .store(in: &self.cancelBag)
        
        output.reload
            .receive(on: DispatchQueue.main)
            .sink(with: self, receiveValue: { controller, _ in
                controller.tableView.reloadData()
            })
            .store(in: &self.cancelBag)
        
        output.isNoSearchResult
            .receive(on: DispatchQueue.main)
            .sink(with: self, receiveValue: { controller, isNoSearchResult in
                controller.noSearchResultLabel.isHidden = !isNoSearchResult
            })
            .store(in: &self.cancelBag)
    }
}

// MARK: MoveTo
extension SearchUserViewController {
    private func replaceLogin() {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        WindowService.shared.replaceRootViewController(navigationController, animated: true)
    }
    
    private func presentSafari(url: URL) {
        let viewController = SFSafariViewController(url: url)
        self.present(viewController, animated: true)
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

// MARK: UITableViewDataSource, UITableViewDelegate
extension SearchUserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GitHubUserCell.self, for: indexPath)
        let user = self.viewModel.user(index: indexPath.row)
        cell.configure(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.viewModel.isLast(index: indexPath.row) else { return }
        self.nextPage.send(())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex.send(indexPath.row)
    }
}

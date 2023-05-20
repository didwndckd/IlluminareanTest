//
//  GitHubUserCell.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import UIKit

final class GitHubUserCell: UITableViewCell, ReusableView {
    private let profileImageView = UIImageView()
    private let textStackView = UIStackView()
    private let userNameLabel = UILabel()
    private let githubUrlLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupAttribute()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupAttribute()
        self.setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
    }
    
    private func setupAttribute() {
        self.selectionStyle = .none
        
        self.profileImageView.contentMode = .scaleToFill
        self.profileImageView.clipsToBounds = true
        
        self.textStackView.axis = .vertical
        self.textStackView.distribution = .equalSpacing
        
        self.userNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        self.githubUrlLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    private func setupLayout() {
        self.contentView.addSubviews(self.profileImageView, self.textStackView)
        
        self.profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(16).priority(999)
            make.width.height.equalTo(40)
        }
        
        self.textStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(16)
            make.top.bottom.equalTo(self.profileImageView)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        [self.userNameLabel, self.githubUrlLabel].forEach { view in
            self.textStackView.addArrangedSubview(view)
        }
    }
    
}

extension GitHubUserCell {
    func configure(user: GitHubUser) {
        self.profileImageView.setImage(user.profileImageUrl)
        self.userNameLabel.text = user.userName
        self.githubUrlLabel.text = user.gitHubPageUrl
    }
}

//
//  GitHubUser.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation

struct GitHubUser {
    let id: Int
    let userName: String
    let gitHubPageUrl: String
    let profileImageUrl: String
}

extension GitHubUser: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "login"
        case gitHubPageUrl = "html_url"
        case profileImageUrl = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.gitHubPageUrl = try container.decode(String.self, forKey: .gitHubPageUrl)
        self.profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
    }
}

//
//  GitHubUserList.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/19.
//

import Foundation

struct GitHubUserList {
    let totalCount: Int
    let users: [GitHubUser]
}

extension GitHubUserList: Decodable {
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case users = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
        self.users = try container.decode([GitHubUser].self, forKey: .users)
    }
}

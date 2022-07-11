//
//  ListUser.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/09.
//

import Foundation

/// リスト表示用ユーザー情報
struct ListUser: Decodable {
    /// id
    var id: Int
    /// ユーザー名
    var userName: String
    /// プロフィール画像 URL
    var avatarUrl: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "login"
        case avatarUrl = "avatar_url"
    }

}

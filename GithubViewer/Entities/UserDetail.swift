//
//  UserDetail.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/09.
//

import Foundation

/// ユーザー情報
struct UserDetail: Decodable {
    /// id
    var id: Int
    /// プロフィール画像 URL
    var avatarUrl: URL?
    /// User Name
    var userName: String
    /// フルネーム
    var fullName: String?
    /// 自己紹介文
    var biography: String?
    /// フォロワー数
    var followers: Int
    /// フォロイー数
    var following: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "login"
        case avatarUrl = "avatar_url"
        case fullName = "name"
        case biography = "bio"
        case followers
        case following
    }

}

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
    /// プロフィール上のユーザー名
    var profileName: String?
    /// 所属企業・団体名
    var company: String?
    /// ブログ
    var blog: String?
    /// e mail
    var email: String?
    /// 自己紹介文
    var biography: String?
    /// 所在地
    var location: String?
    /// twitter user名
    var twitterUserName: String?
    /// パブリックリポジトリ数
    var publicRepos: Int
    /// フォロワー数
    var followers: Int
    /// フォロイー数
    var following: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "login"
        case avatarUrl = "avatar_url"
        case profileName = "name"
        case company
        case blog
        case email
        case biography = "bio"
        case location
        case twitterUserName = "twitter_username"
        case publicRepos = "public_repos"
        case followers
        case following
    }

}

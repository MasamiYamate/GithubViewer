//
//  Repository.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/09.
//

import Foundation

/// リポジトリー情報
struct Repository: Decodable {
    /// id
    var id: Int
    /// リポジトリー名
    var name: String
    /// スター数
    var stargazersCount: Int
    /// 言語
    var language: String?
    /// 説明文
    var description: String?
    /// フォークしたリポジトリであるか
    var isFork: Bool
    /// Web URL
    var htmlURL: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case stargazersCount = "stargazers_count"
        case language
        case description
        case isFork = "fork"
        case htmlURL = "html_url"
    }

}

//
//  EndPoint.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/08.
//

import Foundation

/// APIエンドポイント
enum EndPoint {
    /// Users
    case users
    /// users/USERNAME
    case userDetail(userName: String)
    /// ユーザーのリポジトリを一覧表示する
    case userRepositories(userName: String)

    /// 紐づくパス
    var path: String {
        switch self {
        case .users:
            return "users"
        case .userDetail(let userName):
            return "users/\(userName)"
        case .userRepositories(let userName):
            return "users/\(userName)/repos"
        }
    }

    /// API URL
    var url: URL {
        guard let baseURL = URL(string: "https://api.github.com") else {
            fatalError("URL parse failure")
        }
        return baseURL.appendingPathComponent(self.path, isDirectory: false)
    }

}

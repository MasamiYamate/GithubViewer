//
//  UserModel.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/11.
//

import Foundation

/// ユーザー情報取得
protocol UserModel {

    /// ユーザー情報を取得する
    /// - Parameter userName: ユーザー名
    /// - Returns: ユーザー情報
    func request(userName: String) async throws -> UserDetail

}

/// ユーザー情報取得 実装部
final class UserModelImpl: UserModel {

    /// GithubClient
    private let client: GithubClient

    /// initializer
    /// - Parameter client: GithubClient
    init(client: GithubClient = GithubClientImpl()) {
        self.client = client
    }

    /// ユーザー情報を取得する
    /// - Parameter userName: ユーザー名
    /// - Returns: ユーザー情報
    func request(userName: String) async throws -> UserDetail {
        return try await client.request(endpoint: .userDetail(userName: userName))
    }

}

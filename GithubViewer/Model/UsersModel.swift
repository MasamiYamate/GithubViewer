//
//  ListUserModel.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/10.
//

import Foundation

/// ユーザーの一覧を取得
protocol UsersModel {

    /// ユーザーの一覧情報を取得する
    /// - Parameter since: 指定Id以後の値を取得するための基準値
    /// - Returns: ユーザー一覧
    func request(since: Int?) async throws -> [ListUser]

}

/// ユーザーの一覧を取得 実装部
final class UsersModelImpl: UsersModel {

    /// GithubClient
    private let client: GithubClient

    /// initializer
    /// - Parameter client: GithubClient
    init(client: GithubClient = GithubClientImpl()) {
        self.client = client
    }

    /// ユーザーの一覧情報を取得する
    /// - Parameter since: 指定Id以後の値を取得するための基準値
    /// - Returns: ユーザー一覧
    func request(since: Int?) async throws -> [ListUser] {
        let parameter: UsersRequestParameter? = .init(since: since)
        return try await client.request(endpoint: .users, parameter: parameter)
    }

}

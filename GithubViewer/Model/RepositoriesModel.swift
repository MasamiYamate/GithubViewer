//
//  RepositoriesModel.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/11.
//

import Foundation

/// ユーザーのリポジトリ一覧取得用モデル
protocol RepositoriesModel {

    /// ユーザーと紐づくリポジトリ一覧を取得する
    /// - Parameters:
    ///   - userName: ユーザー名
    ///   - page: 取得するページ数
    /// - Returns: リポジトリー 一覧
    func request(userName: String, page: Int?) async throws -> [Repository]

}

/// ユーザーのリポジトリ一覧取得 実装部
final class RepositoriesModelImpl: RepositoriesModel {

    /// GithubClient
    private let client: GithubClient
    
    /// initializer
    /// - Parameter client: GithubClient
    init(client: GithubClient = GithubClientImpl()) {
        self.client = client
    }

    /// ユーザーと紐づくリポジトリ一覧を取得する
    /// - Parameters:
    ///   - userName: ユーザー名
    ///   - page: 取得するページ数
    /// - Returns: リポジトリー 一覧
    func request(userName: String, page: Int?) async throws -> [Repository] {
        let parameter: RepositoriesRequestParameter? = .init(page: page)
        return try await client.request(endpoint: .userRepositories(userName: userName), parameter: parameter)
    }

}

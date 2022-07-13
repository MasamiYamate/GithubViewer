//
//  UserDetailPresenter.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import Foundation
import UIKit

/// ユーザー詳細画面向けPresenter
protocol UserDetailPresenter {

    /// 初期データの読み込み済み判定フラグ
    var isInitialized: Bool { get }

    /// 読み込み処理中の判定フラグ
    var isLoading: Bool { get }

    /// 初期データの取得処理
    /// - Parameter userName: 検索対象のユーザー名
    func fetchInitialUserData(userName: String) async throws

    /// ユーザーリポジトリの取得処理
    func fetchUserRepositories() async throws

    /// セクションに表示するCell数を返却する
    /// - Parameter section: Section index
    /// - Returns: Cell数
    func fetchSectionInCount(section: Int) -> Int

    /// Cellに紐づくデータを返却する
    /// - Parameter indexPath: CellのIndexPath
    /// - Returns: Cellのデータ
    func fetchCellData(indexPath: IndexPath) -> Any?

}

/// ユーザー詳細画面向けPresenterの実装部
final class UserDetailPresenterImpl: UserDetailPresenter {

    typealias Result = (userData: UserDetail, repositories: [Repository])

    /// 初期データの読み込み済み判定フラグ
    var isInitialized: Bool {
        let hasUserData = userData != nil
        let hasRepositories = !repositories.isEmpty
        return hasUserData && hasRepositories
    }

    /// 読み込み処理中の判定フラグ
    private(set) var isLoading: Bool = false

    private let userModel: UserModel

    private let repositoriesModel: RepositoriesModel

    private var repositories: [[Repository]] = []

    private weak var view: UserDetailView?

    private var userData: UserDetail?

    /// 取得したリポジトリの中で、フォークではないリポジトリの配列
    private var originalRepositories: [Repository] {
        return repositories.reduce([]) { store, repositories in
            return store + repositories
        }.filter { repository in
            let isOriginal = !repository.isFork
            return isOriginal
        }
    }

    init(view: UserDetailView,
         userModel: UserModel = UserModelImpl(),
         repositoriesModel: RepositoriesModel = RepositoriesModelImpl()) {
        self.view = view
        self.userModel = userModel
        self.repositoriesModel = repositoriesModel
    }

    /// 初期データの取得処理
    /// - Parameter userName: 検索対象のユーザー名
    func fetchInitialUserData(userName: String) async throws {
        isLoading = true
        async let userData = userModel.request(userName: userName)
        async let repositories = repositoriesModel.request(userName: userName, page: repositories.count)
        let result: Result = try await (userData: userData, repositories: repositories)
        self.userData = result.userData
        self.repositories.append(result.repositories)
        await view?.tableViewReload()
        isLoading = false
    }

    /// ユーザーリポジトリの取得処理
    func fetchUserRepositories() async throws {
        guard let userData = userData else {
            return
        }
        isLoading = true
        let repositories = try await repositoriesModel.request(userName: userData.userName, page: repositories.count)
        self.repositories.append(repositories)
        await view?.tableViewReload()
        isLoading = false
    }

    /// セクションに表示するCell数を返却する
    /// - Parameter section: Section index
    /// - Returns: Cell数
    func fetchSectionInCount(section: Int) -> Int {
        guard let type = UserDetailTableSection(rawValue: section) else {
            return 0
        }
        switch type {
        case .userData:
            // UserData読み込み完了までは0件
            return userData == nil ? 0 : type.cellSortOrder.count
        case .repositories:
            return originalRepositories.count
        }
    }

    /// Cellに紐づくデータを返却する
    /// - Parameter indexPath: CellのIndexPath
    /// - Returns: Cellのデータ
    func fetchCellData(indexPath: IndexPath) -> Any? {
        guard let type = UserDetailTableSection(rawValue: indexPath.section) else {
            return nil
        }
        switch type {
        case .userData:
            return userData
        case .repositories:
            return originalRepositories[indexPath.row]
        }
    }

}

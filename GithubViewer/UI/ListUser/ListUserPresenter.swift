//
//  ListUserPresenter.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/11.
//

import Foundation

/// ユーザー 一覧画面のPresenter
protocol ListUserPresenter {

    /// 読み込み処理中の判定フラグ
    var isLoading: Bool { get }

    /// ユーザーの読み込みを行う
    func requestLoadUsers() async throws

    /// 取得済みユーザー数
    /// - Returns: ユーザー数
    func fetchUserCount() -> Int

    /// 指定したIndexのユーザー情報を取得する
    /// - Parameter index: 任意のindex
    /// - Returns: ユーザー情報
    func fetchUser(index: Int) -> ListUser?

}

/// ユーザー 一覧画面のPresenter 実装部
final class ListUserPresenterImpl: ListUserPresenter {

    /// 取得済みの一覧ユーザーデータ
    private var users: [ListUser] = [] {
        didSet {
            Task {
                await view?.tableViewReload()
            }
        }
    }

    /// 読み込み処理中の判定フラグ
    private(set) var isLoading: Bool = false

    private weak var view: ListUserView?

    private let userListModel: UserListModel

    init(view: ListUserView,
         userListModel: UserListModel = UserListModelImpl()) {
        self.view = view
        self.userListModel = userListModel
    }

    /// ユーザーの読み込みを行う
    func requestLoadUsers() async throws {
        let since = users.last?.id
        do {
            isLoading = true
            let result = try await userListModel.request(since: since)
            let newUsers = result.filter({ user in
                let isNewUser = users.first(where: { fetchedUser in
                    fetchedUser.id == user.id
                }) == nil
                return isNewUser
            })
            users += newUsers
            isLoading = false
        } catch {
            isLoading = false
            throw error
        }
    }

    /// 取得済みユーザー数
    /// - Returns: ユーザー数
    func fetchUserCount() -> Int {
        return users.count
    }

    /// 指定したIndexのユーザー情報を取得する
    /// - Parameter index: 任意のindex
    /// - Returns: ユーザー情報
    func fetchUser(index: Int) -> ListUser? {
        guard users.indices.contains(index) else {
            return nil
        }
        return users[index]
    }

}

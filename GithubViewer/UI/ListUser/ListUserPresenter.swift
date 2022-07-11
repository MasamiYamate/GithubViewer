//
//  ListUserPresenter.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/11.
//

import Foundation

@MainActor
protocol ListUserPresenter {

    var isLoading: Bool { get }

    func requestLoadUsers() async throws

    func fetchUserCount() -> Int

    func fetchUser(index: Int) -> ListUser?

}

@MainActor
final class ListUserPresenterImpl: ListUserPresenter {

    private var users: [ListUser] = [] {
        didSet {
            view.tableViewReload()
        }
    }

    private(set) var isLoading: Bool = false

    let view: ListUserView

    let userListModel: UserListModel

    init(view: ListUserView,
         userListModel: UserListModel = UserListModelImpl()) {
        self.view = view
        self.userListModel = userListModel
    }

    func requestLoadUsers() async throws {
        let since = users.last?.id
        do {
            isLoading = true
            let result = try await userListModel.request(since: since)
            users += result
            isLoading = false
        } catch {
            isLoading = false
            throw error
        }
    }

    func fetchUserCount() -> Int {
        return users.count
    }

    func fetchUser(index: Int) -> ListUser? {
        guard users.indices.contains(index) else {
            return nil
        }
        return users[index]
    }

}

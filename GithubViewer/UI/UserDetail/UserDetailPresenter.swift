//
//  UserDetailPresenter.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import Foundation
import UIKit

protocol UserDetailPresenter {

    /// 読み込み処理中の判定フラグ
    var isLoading: Bool { get }

    func fetchSectionCount() -> Int

    func fetchSectionInCount(section: Int) -> Int

    func fetchSectionTitle(section: Int) -> String?

    func fetchCellType(indexPath: IndexPath) -> UserDetailCell.Type?

    func fetchCellData(indexPath: IndexPath) -> Any?

    func fetchInitialUserData(userName: String) async throws

    func fetchUserRepositories() async throws

}

final class UserDetailPresenterImpl: UserDetailPresenter {

    typealias Result = (userData: UserDetail, repositories: [Repository])

    private(set) var isLoading: Bool = false

    private weak var view: UserDetailView?

    private let userModel: UserModel

    private let repositoriesModel: RepositoriesModel

    private var userData: UserDetail?

    private var repositories: [[Repository]] = []

    /// Section情報
    private enum Section: Int, CaseIterable {
        case userInfomation
        case repositories

        var title: String {
            switch self {
            case .userInfomation:
                return NSLocalizedString("SectionTitleUser", comment: "")
            case .repositories:
                return NSLocalizedString("SectionTitleRepositories", comment: "")
            }
        }

        var sortOrder: [UserDetailCell.Type] {
            switch self {
            case .userInfomation:
                return [
                    UserDetailNameTableViewCell.self,
                    UserDetailFollowTableViewCell.self,
                    UserDetailBiographyTableViewCell.self
                ]
            case .repositories:
                return [
                    UserDetailRepositoryTableViewCell.self
                ]
            }
        }

    }

    init(view: UserDetailView,
         userModel: UserModel = UserModelImpl(),
         repositoriesModel: RepositoriesModel = RepositoriesModelImpl()) {
        self.view = view
        self.userModel = userModel
        self.repositoriesModel = repositoriesModel
    }

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

    func fetchSectionCount() -> Int {
        return Section.allCases.count
    }

    func fetchSectionTitle(section: Int) -> String? {
        return Section(rawValue: section)?.title
    }

    func fetchSectionInCount(section: Int) -> Int {
        guard let type = Section(rawValue: section) else {
            return 0
        }
        switch type {
        case .userInfomation:
            // UserData読み込み完了までは0件
            return userData == nil ? 0 : type.sortOrder.count
        case .repositories:
            let repositories = fetchedUserRepositories()
            return repositories.count
        }
    }

    func fetchCellType(indexPath: IndexPath) -> UserDetailCell.Type? {
        guard let type = Section(rawValue: indexPath.section) else {
            return nil
        }
        switch type {
        case .userInfomation:
            return type.sortOrder[indexPath.row]
        case .repositories:
            return type.sortOrder.first
        }
    }

    func fetchCellData(indexPath: IndexPath) -> Any? {
        guard let type = Section(rawValue: indexPath.section) else {
            return nil
        }
        switch type {
        case .userInfomation:
            return userData
        case .repositories:
            let repositories = fetchedUserRepositories()
            return repositories[indexPath.row]
        }
    }

}

private extension UserDetailPresenterImpl {

    func fetchedUserRepositories(inclFork: Bool = false) -> [Repository] {
        return repositories.reduce([]) { store, repositories in
            return store + repositories
        }.filter { repository in
            guard !inclFork else {
                return true
            }
            let isOriginal = !repository.isFork
            return isOriginal
        }
    }

}

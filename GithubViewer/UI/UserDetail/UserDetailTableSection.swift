//
//  UserDetailTableSection.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/14.
//

import Foundation

/// Section情報
enum UserDetailTableSection: Int, CaseIterable {
    /// ユーザー情報
    case userData
    /// リポジトリ
    case repositories

    var title: String {
        switch self {
        case .userData:
            return NSLocalizedString("SectionTitleUser", comment: "")
        case .repositories:
            return NSLocalizedString("SectionTitleRepositories", comment: "")
        }
    }

    /// Cellの並び順
    var cellSortOrder: [UserDetailCell.Type] {
        switch self {
        case .userData:
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

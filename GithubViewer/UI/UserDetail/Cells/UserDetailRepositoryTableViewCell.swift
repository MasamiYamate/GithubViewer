//
//  UserDetailRepositoryTableViewCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/13.
//

import UIKit

/// ユーザー情報 リポジトリセル
final class UserDetailRepositoryTableViewCell: UITableViewCell {

    /// リポジトリ名ラベル
    @IBOutlet private weak var nameLabel: UILabel!
    /// 言語表示ラベル
    @IBOutlet private weak var languageLabel: UILabel!
    /// スター数ラベル
    @IBOutlet private weak var stargazersCountLabel: UILabel!
    /// 説明文ラベル
    @IBOutlet private weak var descriptionLabel: UILabel!

}

extension UserDetailRepositoryTableViewCell: UserDetailCell {

    /// Configure
    /// - Parameter data: リポジトリ情報
    @MainActor func configure(data: Any) {
        guard let repository = data as? Repository else {
            return
        }
        nameLabel.text = repository.name
        languageLabel.text = repository.language ?? "-"
        stargazersCountLabel.text = "\(repository.stargazersCount)"
        descriptionLabel.text = repository.description
    }

}

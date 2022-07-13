//
//  UserDetailRepositoryTableViewCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/13.
//

import UIKit

final class UserDetailRepositoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!

    @IBOutlet private weak var languageLabel: UILabel!

    @IBOutlet private weak var stargazersCountLabel: UILabel!

    @IBOutlet private weak var descriptionLabel: UILabel!

}

extension UserDetailRepositoryTableViewCell: UserDetailCell {

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

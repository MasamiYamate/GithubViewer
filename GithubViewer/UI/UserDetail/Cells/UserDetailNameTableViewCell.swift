//
//  UserDetailNameTableViewCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import Kingfisher
import UIKit

/// ユーザー情報 ユーザー名Cell
final class UserDetailNameTableViewCell: UITableViewCell {

    /// アバター用ImageView
    @IBOutlet private weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2.0
            avatarImageView.layer.borderWidth = 1.0
            avatarImageView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    /// ユーザー名ラベル
    @IBOutlet private weak var userNameLabel: UILabel!
    /// フルネーム用ラベル
    @IBOutlet private weak var fullNameLabel: UILabel!

}

extension UserDetailNameTableViewCell: UserDetailCell {

    /// Configure
    /// - Parameter data: User情報
    @MainActor func configure(data: Any) {
        guard let user = data as? UserDetail else {
            return
        }
        avatarImageView.kf.setImage(with: user.avatarUrl)
        userNameLabel.text = user.userName
        fullNameLabel.text = user.fullName
    }

}

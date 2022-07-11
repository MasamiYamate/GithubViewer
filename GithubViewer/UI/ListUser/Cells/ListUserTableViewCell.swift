//
//  ListUserTableViewCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import Kingfisher
import UIKit

@MainActor
/// 一覧画面向け ユーザー情報セル
final class ListUserTableViewCell: UITableViewCell {

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

    /// Configure
    /// - Parameter user: User情報
    func configure(user: ListUser) {
        avatarImageView.kf.setImage(with: user.avatarUrl)
        userNameLabel.text = user.userName
    }

}

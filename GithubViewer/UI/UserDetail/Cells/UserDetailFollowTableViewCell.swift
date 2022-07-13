//
//  UserDetailFollowTableViewCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import UIKit

/// ユーザー情報 フォロワー・フォロイーセル
final class UserDetailFollowTableViewCell: UITableViewCell {

    /// フォロワー数ラベル
    @IBOutlet private weak var followerCountLabel: UILabel!
    /// フォロイー数ラベル
    @IBOutlet private weak var followingCountLabel: UILabel!

}

extension UserDetailFollowTableViewCell: UserDetailCell {

    /// Configure
    /// - Parameter data: User情報
    @MainActor func configure(data: Any) {
        guard let user = data as? UserDetail else {
            return
        }
        followerCountLabel.text = "\(user.followers)"
        followingCountLabel.text = "\(user.following)"
    }

}

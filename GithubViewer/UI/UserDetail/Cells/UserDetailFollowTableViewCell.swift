//
//  UserDetailFollowTableViewCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import UIKit

final class UserDetailFollowTableViewCell: UITableViewCell {

    @IBOutlet private weak var followerCountLabel: UILabel!

    @IBOutlet private weak var followingCountLabel: UILabel!

}

extension UserDetailFollowTableViewCell: UserDetailCell {

    @MainActor func configure(data: Any) {
        guard let user = data as? UserDetail else {
            return
        }
        followerCountLabel.text = "\(user.followers)"
        followingCountLabel.text = "\(user.following)"
    }

}

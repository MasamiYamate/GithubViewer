//
//  UserDetailBiographyTableViewCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/13.
//

import UIKit

/// ユーザー情報 自己紹介文セル
final class UserDetailBiographyTableViewCell: UITableViewCell {

    /// 自己紹介文ラベル
    @IBOutlet private weak var biographyLabel: UILabel!

}

extension UserDetailBiographyTableViewCell: UserDetailCell {

    /// Configure
    /// - Parameter data: User情報
    @MainActor func configure(data: Any) {
        guard let user = data as? UserDetail else {
            return
        }
        biographyLabel.text = user.biography
    }
}

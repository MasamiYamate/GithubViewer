//
//  UserDetailBiographyTableViewCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/13.
//

import UIKit

final class UserDetailBiographyTableViewCell: UITableViewCell {

    @IBOutlet private weak var biographyLabel: UILabel!

}

extension UserDetailBiographyTableViewCell: UserDetailCell {

    @MainActor func configure(data: Any) {
        guard let user = data as? UserDetail else {
            return
        }
        biographyLabel.text = user.biography
    }
}

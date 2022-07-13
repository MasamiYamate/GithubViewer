//
//  UserDetailCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/13.
//

import UIKit

/// ユーザー画面のセルが準拠するCell向けプロトコル
protocol UserDetailCell: UITableViewCell {

    @MainActor func configure(data: Any)

}

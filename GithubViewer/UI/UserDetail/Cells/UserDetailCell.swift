//
//  UserDetailCell.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/13.
//

import Foundation

protocol UserDetailCell: AnyObject {

    @MainActor func configure(data: Any)

}

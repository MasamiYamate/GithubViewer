//
//  UsersRequestParameter.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/11.
//

import Foundation

/// Users(ユーザー一覧)リクエスト時のパラメーター
struct UsersRequestParameter: RequestParameter {
    /// 指定値以降のidを用いて検索する
    var since: Int

    init?(since: Int?) {
        guard let since = since else {
            return nil
        }
        self.since = since
    }
}

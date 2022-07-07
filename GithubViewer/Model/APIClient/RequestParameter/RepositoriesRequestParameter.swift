//
//  RepositoriesRequestParameter.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/11.
//

import Foundation

/// リポジトリーリクエスト時パラメーター
struct RepositoriesRequestParameter: RequestParameter {
    /// 検索対象のページ数 (default 1)
    var page: Int

    init?(page: Int?) {
        guard let page = page else {
            return nil
        }
        self.page = page
    }

}

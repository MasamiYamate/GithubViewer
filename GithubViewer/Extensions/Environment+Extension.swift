//
//  Environment+Extension.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/10.
//

import Foundation

/// 自動生成されるEnvironmentのExtension
extension Environment {

    /// App内で利用する秘匿情報のKeyを記載
    enum Key: String {
        case githubToken = "GIT_HUB_TOKEN"

        var value: String {
            guard let value = Environment.items[self.rawValue] else {
                fatalError("Load Failure")
            }
            return value
        }
    }

}

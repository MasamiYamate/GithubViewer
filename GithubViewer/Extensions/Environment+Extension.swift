//
//  Environment+Extension.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/10.
//

import Foundation

extension Environment {

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

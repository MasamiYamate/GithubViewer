//
//  APIClientError.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/08.
//

import Foundation

/// APIClient向けエラー
enum APIClientError: Error {
    /// レスポンスがない
    case notFoundResponse
}

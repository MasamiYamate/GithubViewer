//
//  RequestParameter.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/08.
//

import Foundation

protocol RequestParameter: Codable {

    /// Dictionaryに変換する
    /// - Returns: 変換後のDictionary
    func toDictionary() -> [String: Any]

}

extension RequestParameter {

    /// Dictionaryに変換する
    /// - Returns: 変換後のDictionary
    func toDictionary() -> [String: Any] {
        guard
            let data = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }

}

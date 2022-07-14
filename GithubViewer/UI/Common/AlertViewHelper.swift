//
//  AlertViewHelper.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import UIKit

/// アラート表示のヘルパークラス
final class AlertViewHelper {

    /// 表示コンテンツの引数用モデル
    struct Contents {
        var title: String
        var message: String?
        var style: UIAlertController.Style
    }

    /// アラートを表示する
    /// - Parameters:
    ///   - viewController: 表示元のView controller
    ///   - contents: 表示コンテンツ
    ///   - actions: 設定するUIAlertActionの配列
    static func present(viewController: UIViewController, contents: Contents, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: contents.title, message: contents.message, preferredStyle: contents.style)
        actions.forEach { alert.addAction($0) }
        viewController.present(alert, animated: true)
    }

}

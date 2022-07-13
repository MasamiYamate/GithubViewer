//
//  Instantiatable.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import UIKit

/// StoryboardからVCを初期化するテンプレート
protocol Instantiatable: UIViewController {

    associatedtype ViewControllerType: UIViewController

    /// 任意のView controllerを初期化する
    /// - Returns: UIView controllerを継承したクラス
    static func instantiate() -> ViewControllerType?

}

extension Instantiatable {

    /// 任意のView controllerを初期化する
    /// - Returns: UIView controllerを継承したクラス
    static func instantiate() -> ViewControllerType? {
        let className = String(describing: ViewControllerType.self)
        let storyboard = UIStoryboard(name: className, bundle: nil)
        return storyboard.instantiateInitialViewController() as? ViewControllerType
    }

}

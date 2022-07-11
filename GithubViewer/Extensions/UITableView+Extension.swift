//
//  UICollectionView+Extension.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import UIKit

extension UITableView {

    /// カスタムCellを登録する
    /// - Parameter type: UITableViewCellを継承したクラス
    func register<T: UITableViewCell>(type: T.Type) {
        let name = String(describing: type)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }

    /// 指定したカスタムセルを取得する
    /// - Parameter type: UITableViewCellを継承したクラス
    /// - Returns: UITableViewCellを継承したCellインスタンス
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: type)) as? T else {
            return nil
        }
        return cell
    }

}

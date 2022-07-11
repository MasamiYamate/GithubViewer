//
//  UICollectionView+Extension.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(type: T.Type) {
        let name = String(describing: type)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: type)) as? T else {
            return nil
        }
        return cell
    }

}

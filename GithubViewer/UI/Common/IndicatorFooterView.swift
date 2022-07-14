//
//  IndicatorFooterView.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/11.
//

import UIKit

/// ローディング表示用のFooterView
final class IndicatorFooterView: UIView {

    private let indicatorView = UIActivityIndicatorView()

    init() {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0)
        super.init(frame: rect)
        Task {
            await setupConstraint()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// indicatorViewのアニメーション開始
    @MainActor func startAnimating() {
        indicatorView.startAnimating()
    }

    /// indicatorViewのアニメーション停止
    @MainActor func stopAnimating() {
        indicatorView.stopAnimating()
    }

}

private extension IndicatorFooterView {

    /// レイアウトの設定
    @MainActor func setupConstraint() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.heightAnchor.constraint(equalToConstant: 20.0),
            indicatorView.widthAnchor.constraint(equalToConstant: 20.0),
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}

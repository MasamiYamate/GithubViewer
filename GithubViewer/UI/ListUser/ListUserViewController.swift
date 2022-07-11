//
//  ListUserViewController.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/06.
//

import UIKit

@MainActor
protocol ListUserView {

    func tableViewReload()

}

@MainActor
/// ユーザー 一覧画面
final class ListUserViewController: UIViewController, ListUserView {

    /// TableView footer view
    private let footerView = IndicatorFooterView()

    /// ListUserPresenter
    private lazy var presenter: ListUserPresenter = ListUserPresenterImpl(view: self)

    /// スクロール中のユーザー情報の取得開始位置
    private var fetchScrollPosition: CGFloat {
        /// コンテンツサイズから-50の位置で新しいユーザーデータをリクエストする
        return tableView.contentSize.height - UIScreen.main.bounds.size.height - 50
    }

    /// TableView
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadUsers()
    }

    /// TableViewの再読み込みを行う
    func tableViewReload() {
        tableView.reloadData()
    }

}

private extension ListUserViewController {

    /// TableViewの設定を行う
    func setupTableView() {
        tableView.register(type: ListUserTableViewCell.self)
        tableView.tableFooterView = footerView
        tableView.dataSource = self
        tableView.delegate = self
    }

    /// User情報を取得する
    func loadUsers() {
        guard !presenter.isLoading else {
            return
        }
        Task {
            do {
                try await presenter.requestLoadUsers()
                footerView.stopAnimating()
            } catch {
                footerView.stopAnimating()
                showErrorAlert(error: error)
            }
        }
    }

    /// エラーアラートを表示する
    /// - Parameter error: Error
    func showErrorAlert(error: Error) {
        // TODO: Errorを引数で受け取っているが、エラー内容によって文言を変化させることを今後想定
        AlertViewController.present(
            viewController: self,
            contents: .init(title: NSLocalizedString("ErrorAlertSorryTitle", comment: ""),
                            message: NSLocalizedString("ErrorAlertFetchFailureMessage", comment: ""),
                            style: .alert),
            actions: [
                UIAlertAction(title: NSLocalizedString("ErrorAlertCloseButtonTitle", comment: ""),
                              style: .cancel),
                UIAlertAction(title: NSLocalizedString("ErrorAlertRetryButtonTitle", comment: ""),
                              style: .default,
                              handler: { [weak self] _ in
                                self?.loadUsers()
                              }
                )
            ]
        )
    }

}

extension ListUserViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.fetchUserCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(type: ListUserTableViewCell.self),
              let user = presenter.fetchUser(index: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(user: user)
        return cell
    }

}

extension ListUserViewController: UITableViewDelegate {

}

extension ListUserViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= fetchScrollPosition else {
            return
        }
        footerView.startAnimating()
        loadUsers()
    }

}

//
//  ListUserViewController.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/06.
//

import UIKit

/// ユーザー 一覧画面
protocol ListUserView: AnyObject {

    /// TableViewの再読み込みを行う
    @MainActor func tableViewReload()

}

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
        configure()
        loadUsers()
    }

    /// TableViewの再読み込みを行う
    @MainActor func tableViewReload() {
        tableView.reloadData()
    }

}

private extension ListUserViewController {

    /// Viewの設定を行う
    @MainActor func configure() {
        tableView.register(type: ListUserNameTableViewCell.self)
        tableView.tableFooterView = footerView
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.title = NSLocalizedString("NavigationTitleUsers", comment: "")
    }

    /// User情報を取得する
    func loadUsers() {
        guard !presenter.isLoading else {
            return
        }
        footerView.startAnimating()
        Task {
            do {
                try await presenter.requestLoadUsers()
            } catch {
                showErrorAlert()
            }
            footerView.stopAnimating()
        }
    }

    /// エラーアラートを表示する
    @MainActor func showErrorAlert() {
        AlertViewHelper.present(
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

    func transitUserDetailView(user: ListUser) {
        guard let detailView = UserDetailViewController.instantiate() else {
            return
        }
        detailView.setUser(name: user.userName)
        navigationController?.pushViewController(detailView, animated: true)
    }

}

extension ListUserViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.fetchUserCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(type: ListUserNameTableViewCell.self),
              let user = presenter.fetchUser(index: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(user: user)
        return cell
    }

}

extension ListUserViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let user = presenter.fetchUser(index: indexPath.row) else {
            return
        }
        transitUserDetailView(user: user)
    }

}

extension ListUserViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= fetchScrollPosition else {
            return
        }
        loadUsers()
    }

}

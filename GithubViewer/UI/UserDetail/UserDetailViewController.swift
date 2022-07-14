//
//  UserDetailViewController.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import KRProgressHUD
import UIKit
import SafariServices

/// ユーザー詳細画面
protocol UserDetailView: AnyObject {

    /// 表示するUser名を設定する
    /// - Parameter name: 表示対象のユーザー名
    func setUser(name: String)

    /// TableViewの再読み込みを行う
    @MainActor func tableViewReload()

}

/// ユーザー詳細画面 実装部
final class UserDetailViewController: UIViewController, UserDetailView, Instantiatable {
    /// Instantiatable用の型指定
    typealias ViewControllerType = UserDetailViewController

    /// TableView footer view
    private let footerView = IndicatorFooterView()

    private lazy var presenter: UserDetailPresenter = UserDetailPresenterImpl(view: self)

    /// スクロール中のユーザー情報の取得開始位置
    private var fetchScrollPosition: CGFloat {
        /// コンテンツサイズから-50の位置で新しいユーザーデータをリクエストする
        return tableView.contentSize.height - UIScreen.main.bounds.size.height - 50
    }

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    /// ユーザー名を設定する
    /// - Parameter name: 表示対象のユーザー名
    func setUser(name: String) {
        KRProgressHUD.show()
        Task {
            do {
                try await presenter.fetchInitialUserData(userName: name)
            } catch {
                showErrorAlert(actions: [
                    .init(title: NSLocalizedString("ErrorAlertCloseButtonTitle", comment: ""),
                          style: .cancel,
                          handler: { [weak self] _ in
                            self?.popViewController()
                          })
                ])
            }
        }
    }

    /// TableViewのリロード処理
    @MainActor func tableViewReload() {
        tableView.reloadData()
        footerView.stopAnimating()
        if KRProgressHUD.isVisible {
            KRProgressHUD.dismiss()
        }
    }

}

private extension UserDetailViewController {

    /// View Configure
    func configure() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .done,
            target: self,
            action: #selector(popViewController)
        )

        tableView.tableFooterView = footerView
        tableView.dataSource = self
        tableView.delegate = self
        let cells: [UserDetailCell.Type] = UserDetailTableSection
            .allCases
            .reduce([]) { store, section in
                return store + section.cellSortOrder
            }
        cells.forEach { cellType in
            tableView.register(type: cellType.self)
        }
    }

    /// 前の画面へ戻す
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    /// 追加のリポジトリ取得処理
    func addRepositoryLoad() {
        guard presenter.isInitialized,
              !presenter.isLoading else {
            return
        }
        footerView.startAnimating()
        Task {
            do {
                try await presenter.fetchUserRepositories()
            } catch {
                showErrorAlert(actions: [
                    .init(title: NSLocalizedString("ErrorAlertCloseButtonTitle", comment: ""),
                          style: .cancel),
                    .init(title: NSLocalizedString("ErrorAlertRetryButtonTitle", comment: ""),
                          style: .default,
                          handler: { [weak self] _ in
                            self?.addRepositoryLoad()
                          }
                    )
                ])
            }
            footerView.stopAnimating()
        }
    }

    /// エラーアラートを表示する
    /// - Parameter actions: アラートに表示するAction
    @MainActor func showErrorAlert(actions: [UIAlertAction]) {
        KRProgressHUD.dismiss()
        AlertViewHelper.present(
            viewController: self,
            contents: .init(title: NSLocalizedString("ErrorAlertSorryTitle", comment: ""),
                            message: NSLocalizedString("ErrorAlertFetchFailureMessage", comment: ""),
                            style: .alert),
            actions: actions
        )
    }

    /// リポジトリ表示用WebViewへ遷移
    /// - Parameter repository: リポジトリデータ
    @MainActor func transitRepositoryWebView(repository: Repository) {
        guard let url = repository.htmlURL else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }

}

extension UserDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return UserDetailTableSection.allCases.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.textLabel?.text = UserDetailTableSection(rawValue: section)?.title
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.fetchSectionInCount(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = UserDetailTableSection(rawValue: indexPath.section) else {
            fatalError("Unconfigured section")
        }
        var cellType: UserDetailCell.Type?
        switch sectionType {
        case .userData:
            cellType = sectionType.cellSortOrder[indexPath.row]
        case .repositories:
            cellType = sectionType.cellSortOrder.first
        }
        guard let cellType = cellType,
              let data = presenter.fetchCellData(indexPath: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: cellType.self)) as? UserDetailCell else {
            fatalError("Cell initialize failure")
        }
        cell.configure(data: data)
        return cell
    }

}

extension UserDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = presenter.fetchCellData(indexPath: indexPath)
        switch data {
        case let repository as Repository:
            transitRepositoryWebView(repository: repository)
        default:
            break
        }
    }

}

extension UserDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= fetchScrollPosition else {
            return
        }
        addRepositoryLoad()
    }

}

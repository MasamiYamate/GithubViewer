//
//  UserDetailViewController.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/12.
//

import KRProgressHUD
import UIKit

protocol UserDetailView: AnyObject {

    func setUser(name: String)

    /// TableViewの再読み込みを行う
    @MainActor func tableViewReload()

}

final class UserDetailViewController: UIViewController, UserDetailView, Instantiatable {

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
        configureTableView()
    }

    func setUser(name: String) {
        KRProgressHUD.show()
        Task {
            do {
                try await presenter.fetchInitialUserData(userName: "MasamiYamate")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    @MainActor func tableViewReload() {
        tableView.reloadData()
        footerView.stopAnimating()
        if KRProgressHUD.isVisible {
            KRProgressHUD.dismiss()
        }
    }

}

private extension UserDetailViewController {

    func configure() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .done,
            target: self,
            action: #selector(popViewController)
        )
    }

    func configureTableView() {
        tableView.tableFooterView = footerView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(type: UserDetailNameTableViewCell.self)
        tableView.register(type: UserDetailFollowTableViewCell.self)
        tableView.register(type: UserDetailRepositoryTableViewCell.self)
        tableView.register(type: UserDetailBiographyTableViewCell.self)
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    func addRepositoryLoad() {
        guard !presenter.isLoading else {
            return
        }
        footerView.startAnimating()
        Task {
            do {
                try? await presenter.fetchUserRepositories()
            } catch {

            }
            footerView.stopAnimating()
        }
    }

}

extension UserDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.fetchSectionCount()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.textLabel?.text = presenter.fetchSectionTitle(section: section)
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.fetchSectionInCount(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = presenter.fetchCellType(indexPath: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type.self)) else {
            return UITableViewCell()
        }
        if let cell = cell as? UserDetailCell,
           let data = presenter.fetchCellData(indexPath: indexPath) {
            cell.configure(data: data)
        }
        return cell
    }

}

extension UserDetailViewController: UITableViewDelegate {

}

extension UserDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= fetchScrollPosition else {
            return
        }
        addRepositoryLoad()
    }

}

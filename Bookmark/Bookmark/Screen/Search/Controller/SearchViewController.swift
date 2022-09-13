//
//  SearchViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    // MARK: - Property
    
    private let searchView = SearchView()
    
    let resultArray = ["북카페 파오", "이북카페", "최인아책방", "문학살롱", "초고산점"]
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupAction()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        searchView.result = resultArray.count
    }
    
    // MARK: - Custom Method
    
    private func setupDelegate() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
    }
    
    private func setupAction() {
        searchView.backButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Protocol

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell
        else { return UITableViewCell() }
        cell.storeLabel.text = resultArray[indexPath.row]

        if let searchWord = searchView.searchBar.text {
            cell.storeLabel.changeSearchTextColor(cell.storeLabel.text, searchWord)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = DetailViewController()
        viewController.navigationBar.titleLabel.text = resultArray[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

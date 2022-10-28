//
//  SearchViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    // MARK: - Property
    
    private var isSearching = true
    
    private let searchView = SearchView()
    private let searchViewModel = SearchViewModel()
    
    private var filterredList: [BookStoreInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchView.tableViewReload()
            }
        }
    }
    private var bookStoreList: [BookStoreInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchView.tableViewReload()
            }
        }
    }
        
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        requestAPI()
        bind()
    }
    
    // MARK: - Configure UI & Layout
    
    override func setupDelegate() {
        searchView.setupTableView(self, self)
        searchView.setupSearchBarDelegate(self)
    }
    
    // MARK: - Bind Data
    
    private func bind() {
        
    }
    
    // MARK: - Network
    
    private func requestAPI() {
        StoreAPIManager.shared.fetchBookStore(endIndex: 1000) { [weak self] (data, status, error) in
            guard let self = self,
                  let data = data else { return }
            self.bookStoreList = data.total.info
        }
    }
    
    // MARK: - Custom Method
 
    private func setupAction() {
        searchView.backButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private func divideCaseOfData(_ index: Int) -> BookStoreInfo {
        let data = filterredList.count == 0 ? bookStoreList : filterredList
        return data[index]
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        transition(self, .pop)
    }
}

// MARK: - TableView Protocol

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchView.result = filterredList.count == 0 ? bookStoreList.count : filterredList.count
        return filterredList.count == 0 ? bookStoreList.count : filterredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell
        else { return UITableViewCell() }
        cell.setupData(divideCaseOfData(indexPath.row))

        // MARK: - TODO 기능 구현하면서 cell 관련 UI니까 쪽으로 분리시키기 + 색대응 오류 발견
        if isSearching {
            if let searchWord = searchView.searchBar.text {
                cell.storeLabel.changeSearchTextColor(cell.storeLabel.text, searchWord)
            }
        } else {
            if let searchWord = searchView.searchBar.text {
                cell.storeLabel.changeSearchTextColor(cell.storeLabel.text, searchWord, color: Color.black100)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = DetailViewController()
        transition(viewController, .push) { _ in
            viewController.detailStoreInfo = self.divideCaseOfData(indexPath.row)
        }
    }
}

// MARK: - SearchBar Protocol

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        isSearching = true
        guard let text = searchBar.text else { return false }
        filterredList = self.bookStoreList.filter { $0.name.contains(text) }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        guard let text = searchBar.text else { return }
        filterredList = self.bookStoreList.filter { $0.name.contains(text) }
        searchView.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text == "" {
            isSearching = false
            filterredList.removeAll()
        } else {
            isSearching = true
            filterredList = self.bookStoreList.filter { $0.name.contains(text) }
        }
    }
}

//
//  SearchViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import RxSwift

final class SearchViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let searchView = SearchView()
    private let searchViewModel = SearchViewModel()
    
    private var isSearching = true
        
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
        checkNetworkStatus()
//        bindViewModel()
    }
    
    // MARK: - Configure UI & Layout
    
    override func setupDelegate() {
        searchView.setupTableView(self, self)
        searchView.setupSearchBarDelegate(self)
    }
    
    // MARK: - Bind ViewModel 리팩토링 필요!
    
    // 1. 테이블뷰에 셀 등록하기 - SearchView에서 이미 해주고 있음
    // 2. 데이터를 테이블뷰에 바인딩하기 -
    // * 여기서 중요한 것은 기존에 테이블뷰 델리게이트는 없애줘도 된다.
    
    private func bindViewModel() {
        
        // 뷰모델이 에피아이 클래스한테 서버통신을 요청
        // 에피아이 클래스가 서버통신 후 콜백으로 뷰모델한테 데이터를 던져주면 받아서 가공해서 데이터를 던져줌
        searchViewModel.requestBookStore()
        
        searchViewModel.bookstoreList
            .bind(to: searchView.tableView.rx.items(
                cellIdentifier: SearchTableViewCell.identifier,
                cellType: SearchTableViewCell.self)) { (row, element, cell) in
                    cell.setupData(element)
                }
                .disposed(by: disposeBag)
        
        // 뷰모델이 데이터를 이렇게 던져주는 것임
        // 2. 데이터를 테이블뷰에 바인딩하기
        // 3. bind 쓴 거는 UI에 특화시켜준 것 - Main 스레드
        searchViewModel.bookstoreList
            .withUnretained(self)
            .bind { (vc, value) in
                vc.searchView.resultLabel.text = "total".localized + " \(value.count)" + "storeUnit".localized
            }
            .disposed(by: disposeBag)

        // 여기까지 테이블뷰 구성은 했어
        
        // 검색창을 구현해야함
        // 1. 검색어 입력 시에 -> 테이블뷰에 검색어 관련 내용이 나와야 함
        
        searchView.searchBar.searchTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                vc.searchViewModel.filterBookStore(text: value)
            }
            .disposed(by: disposeBag)
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
    
    private func checkNetworkStatus() {
        NetworkMonitor.shared.changeUIBytNetworkConnection(vc: self) {
            self.requestAPI()
        }
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

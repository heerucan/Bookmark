//
//  SearchView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

final class SearchView: BaseView {
    
    // MARK: - Property
    
    var result = 0 {
        willSet {
            resultLabel.text = "검색 결과 \(newValue)개"
        }
    }
    
    let backButton = UIButton().then {
        $0.setImage(Icon.Button.back, for: .normal)
    }
    
    private lazy var searchBackView = UIView().then {
        $0.addSubviews([searchBar, searchIconView])
        $0.backgroundColor = Color.gray500
        $0.makeCornerStyle(width: 0, color: nil, radius: 5)
    }
    
    private let searchIconView = UIImageView().then {
        $0.image = Icon.Image.search
    }
    
    let searchBar = UISearchBar().then {
        $0.becomeFirstResponder()
    }
    
    lazy var resultLabel = UILabel().then {
        $0.font = Font.body8.font
        $0.textColor = Color.black100
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.keyboardDismissMode = .onDrag
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSearchBar()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        
        self.addSubviews([backButton,
                          searchBackView,
                         resultLabel,
                         tableView])
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(6)
            make.leading.equalToSuperview()
        }
        
        searchBackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.equalTo(backButton.snp.trailing).offset(2)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        searchIconView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(searchIconView.snp.trailing).inset(10)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    private func setupSearchBar() {
        searchBar.clipsToBounds = true
        searchBar.tintColor = Color.black100
        searchBar.backgroundColor = Color.gray500
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = Color.gray500
        searchBar.searchTextField.textColor = Color.black100
        searchBar.searchTextField.font = Font.body5.font
        searchBar.makeCornerStyle(width: 0, color: nil, radius: 5)
        let attributedString = NSMutableAttributedString(
            string: "책방을 검색해주세요",
            attributes: [.foregroundColor: Color.gray300,
                         .font: Font.body5.font])
        searchBar.searchTextField.attributedPlaceholder = attributedString
        searchBar.searchTextField.leftView = .none
    }
    
    func setupTableView(_ delegate: UITableViewDelegate, _ datasource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = datasource
    }
    
    func setupSearchBarDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func tableViewReload() {
        tableView.reloadData()
    }
}

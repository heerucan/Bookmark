//
//  HomeView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

final class HomeView: BaseView {
    
    // MARK: - Property
    
    private let searchBackView = UIView().then {
        $0.backgroundColor = Color.gray500
        $0.makeCornerStyle(width: 0, color: nil, radius: 5)
    }
    
    private let searchIconView = UIImageView().then {
        $0.image = Icon.Image.search
    }
    
    private let searchBar = UISearchBar()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        self.addSubviews([searchBackView])
        searchBackView.addSubviews([searchBar, searchIconView])
        
        searchBackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
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
}

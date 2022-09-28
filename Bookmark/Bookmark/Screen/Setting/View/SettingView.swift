//
//  SettingView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import UIKit

final class SettingView: BaseView {
    
    // MARK: - Property
    
    let navigationBar = BookmarkNavigationBar(type: .setting)
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.sectionHeaderTopPadding = 0
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.register(SettingTableViewCell.self,
                    forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
        
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([navigationBar,
                          tableView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    func configureDelegate(_ delegate: UITableViewDelegate, _ dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
}

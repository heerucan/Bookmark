//
//  PhraseView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/20.
//

import UIKit

final class PhraseView: BaseView {
    
    // MARK: - Property
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(BookmarkPhraseTableViewCell.self,
                    forCellReuseIdentifier: BookmarkPhraseTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.allowsSelection = false
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureTableViewDelegate(_ delegate: UITableViewDelegate, _ datasource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = datasource
    }
}

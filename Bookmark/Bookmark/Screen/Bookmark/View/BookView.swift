//
//  BookView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/20.
//

import UIKit

import RealmSwift

final class BookView: BaseView {
    
    // MARK: - Realm
    
    let repository = BookmarkRepository.shared
    
    var tasks: Results<Record>! {
        didSet {
            tableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name("countBook"), object: tasks.count)
            print("📪tableView 변화 발생", tasks)
        }
    }
    
    // MARK: - Property
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(BookmarkBookTableViewCell.self,
                    forCellReuseIdentifier: BookmarkBookTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.allowsSelection = false
    }
    
    let emptyStateView = UIImageView().then {
        $0.image = Icon.Image.emptyState
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([tableView,
                          emptyStateView])
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(160)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureTableViewDelegate(_ delegate: UITableViewDelegate, _ datasource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = datasource
    }

    // MARK: - Custom Method
    
    func fetchRealm() {
        self.tasks = repository.fetchRecord("false")
    }
}

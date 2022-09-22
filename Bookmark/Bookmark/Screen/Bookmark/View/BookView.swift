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
    
    let repository = BookmarkRepository()
    
    var tasks: Results<Record>! {
        didSet {
            collectionView.reloadData()
            print("📪collectionView 변화 발생", tasks)
        }
    }
    
    // MARK: - Property
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width-3)/2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .vertical
        return layout
    }()
    
    let emptyStateView = UIImageView().then {
        $0.image = Icon.Image.emptyState
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([collectionView,
                          emptyStateView])
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(235)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureDelegate(_ delegate: UICollectionViewDelegate, _ dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.register(BookmarkBookCollectionViewCell.self,
                                forCellWithReuseIdentifier: BookmarkBookCollectionViewCell.identifier)
    }
    
    // MARK: - Custom Method
    
    func fetchRealm() {
        self.tasks = repository.fetchRecord("false")
    }
}

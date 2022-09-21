//
//  BookView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/20.
//

import UIKit

final class BookView: BaseView {
    
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
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureDelegate(_ delegate: UICollectionViewDelegate, _ dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.register(BookmarkBookCollectionViewCell.self,
                                forCellWithReuseIdentifier: BookmarkBookCollectionViewCell.identifier)
    }
}


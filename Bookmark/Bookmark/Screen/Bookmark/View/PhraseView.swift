//
//  PhraseView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/20.
//

import UIKit

import RealmSwift

final class PhraseView: BaseView {
    
    // MARK: - Realm
    
    let repository = BookmarkRepository.shared
    
    var tasks: Results<Record>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Property
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(BookmarkPhraseTableViewCell.self,
                    forCellReuseIdentifier: BookmarkPhraseTableViewCell.identifier)
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
                          collectionView,
                          emptyStateView])
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(160)
            make.centerX.equalToSuperview()
        }
    }

    func configureTableViewDelegate(_ delegate: UITableViewDelegate,
                                    _ datasource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = datasource
    }
    
    // MARK: - Custom Method
    
    func fetchRealm() {
        self.tasks = repository.fetchRecord("true")
    }
}

// MARK: - Compositional Layout

extension PhraseView {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item])
            
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(86))
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: SettingViewController.sectionFooterElementKind,
                alignment: .bottom
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [footer]
            return section
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = createCompositionalLayout()
//        configuration.scrollDirection = .horizontal
        layout.configuration = configuration
        return layout
    }
}

//
//  BookViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/21.
//

import UIKit

final class BookViewController: BaseViewController {
    
    // MARK: - Property
    
    private let bookView = BookView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = bookView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookView.fetchRealm()
    }
    
    // MARK: - Configure UI & Layout

    override func setupDelegate() {
        bookView.configureDelegate(self, self)
    }
}

// MARK: - UICollectionView Protocol

extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bookView.emptyStateView.isHidden = (bookView.tasks.count != 0) ? true : false
        return bookView.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkBookCollectionViewCell.identifier, for: indexPath) as? BookmarkBookCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setupData(data: bookView.tasks[indexPath.item])
        return cell
    }
}

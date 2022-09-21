//
//  BookViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/21.
//

import UIKit

final class BookViewController: BaseViewController {
    
    // MARK: - Property
    
    let bookView = BookView()
    
    private let bookList = [BookWrite(date: "2022.09.12", name: "북카페파오", image: Icon.Image.gallery),
                            BookWrite(date: "2022.12.12", name: "미스터리유니온", image: Icon.Image.gallery),
                            BookWrite(date: "2012.04.22", name: "교보문고 광화문점", image: Icon.Image.gallery)]
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = bookView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureDelegate()
    }
    
    // MARK: - Configure UI & Layout

    private func configureDelegate() {
        bookView.configureDelegate(self, self)
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}

// MARK: - UICollectionView Protocol

extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkBookCollectionViewCell.identifier, for: indexPath) as? BookmarkBookCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setupData(data: bookList[indexPath.item])
        return cell
    }
}

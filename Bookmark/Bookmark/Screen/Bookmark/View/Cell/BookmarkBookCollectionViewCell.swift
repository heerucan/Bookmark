//
//  BookmarkBookCollectionViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import UIKit

final class BookmarkBookCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    private let dateLabel = UILabel().then {
        $0.font = Font.body8.font
        $0.textColor = Color.gray100
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    lazy var bookImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.addSubview(bookLabel)
    }
    
    private let bookLabel = UILabel().then {
        $0.text = "책방이름없음"
        $0.font = Font.body1.font
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        contentView.addSubview(bookImageView)
        
        bookImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo((self.frame.width-3)/2)
        }
        
        bookLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
            make.trailing.lessThanOrEqualTo(bookLabel.snp.trailing).inset(12)
        }
    }
    
    // MARK: - Set Up Data
    
    func setupData(data: Record) {
        // MARK: - TODO 이미지 처리하기
//        bookImageView.image = data.image
        
        if let name = data.store?.name {
            bookLabel.text = name
        } else {
            bookLabel.text = "책방 어딘가"
        }
    }
}
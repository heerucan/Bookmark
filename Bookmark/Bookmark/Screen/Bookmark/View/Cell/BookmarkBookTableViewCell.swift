//
//  BookmarkBookTableViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import UIKit

final class BookmarkBookTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    lazy var bookImageView = UIImageView().then {
        $0.backgroundColor = Color.gray500
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let moreButton = UIButton().then {
        $0.setImage(Icon.Button.more, for: .normal)
    }
    
    private let tagView = BookmarkBoxView().then {
        $0.subLabel.text = "#책"
    }
    
    private let bookView = BookmarkBoxView()
    private let storeView = BookmarkBoxView()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([bookImageView,
                                 moreButton,
                                 tagView,
                                 bookView,
                                 storeView])
        
        bookImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.top)
            make.trailing.equalTo(bookImageView.snp.trailing).inset(16)
            make.width.equalTo(24)
            make.height.equalTo(20)
        }
        
        tagView.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        bookView.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(15)
            make.leading.equalTo(tagView.snp.trailing).offset(5)
            make.height.equalTo(24)
        }
        
        storeView.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(15)
            make.leading.equalTo(bookView.snp.trailing).offset(5)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
    }
    
    // MARK: - Set Up Data
    
    func setupData(record: Record) {
        guard let name = record.store?.name,
              let title = record.title else { return }
        storeView.subLabel.text = name
        if name.isEmpty {
            storeView.subLabel.text = "책방 어딘가"
        }
        if title.isEmpty {
            bookView.subLabel.text = "어떤 책에서"
        }
    }
}

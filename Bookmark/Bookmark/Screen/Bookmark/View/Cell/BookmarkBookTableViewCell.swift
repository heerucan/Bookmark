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
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Color.gray500.cgColor
    }
    
    let moreButton = UIButton().then {
        $0.setImage(Icon.Button.more, for: .normal)
    }
    
    private let tagView = BookmarkBoxView().then {
        $0.subLabel.text = "#책"
    }

    private let storeView = BookmarkBoxView()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        contentView.backgroundColor = .white
    }
    
    override func configureLayout() {
        contentView.addSubviews([bookImageView,
                                 moreButton,
                                 tagView,
                                 storeView])
        
        bookImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(bookImageView.snp.width)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.top)
            make.trailing.equalTo(bookImageView.snp.trailing).inset(6)
        }
        
        tagView.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        storeView.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(16)
            make.leading.equalTo(tagView.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailing).inset(16)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
    }
    
    // MARK: - Set Up Data
    
    func setupData(record: Record) {
        guard let name = record.store?.name else { return }
        if name.isEmpty {
            storeView.isHidden = true
        } else {
            storeView.subLabel.text = name
        }
    }
}

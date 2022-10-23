//
//  BookmarkPhraseTableViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/21.
//

import UIKit

final class BookmarkPhraseTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    let phraseImageView = UIImageView().then {
        $0.backgroundColor = Color.gray500
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let moreButton = UIButton().then {
        $0.setImage(Icon.Button.more, for: .normal)
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Font.body7.font
        $0.textColor = Color.gray100
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [bookView, storeView]).then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let phraseView = BookmarkBoxView().then {
        $0.subLabel.text = "#글"
    }

    private let bookView = BookmarkBoxView()
    private let storeView = BookmarkBoxView()
        
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configure UI & Layout

    override func configureLayout() {
        contentView.addSubviews([phraseImageView,
                                 moreButton,
                                 dateLabel,
                                 phraseView,
                                 stackView])
        
        phraseImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(phraseImageView.snp.width).multipliedBy(1)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(phraseImageView.snp.top)
            make.trailing.equalTo(phraseImageView.snp.trailing).inset(6)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(phraseImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        phraseView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(13)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(39)
            make.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(13)
            make.leading.equalTo(phraseView.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailing).inset(16)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
    }
        
    // MARK: - Set Up Data
    
    func setupData(record: Record) {
        guard let name = record.store?.name,
              let title = record.title else { return }
        storeView.subLabel.text = "#" + name
        bookView.subLabel.text = title
        dateLabel.text = record.createdAt.toString()
        if name.isEmpty {
            storeView.isHidden = true
        }
        if title.isEmpty {
            bookView.isHidden = true
        }
    }
}

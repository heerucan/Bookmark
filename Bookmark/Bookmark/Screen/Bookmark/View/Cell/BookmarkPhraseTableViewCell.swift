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
        $0.makeCornerStyle(width: 0, color: nil, radius: 10)
        $0.backgroundColor = .lightGray
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Font.body8.font
        $0.textColor = Color.gray100
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private lazy var bookLabel = UILabel().then {
        $0.font = Font.body8.font
        $0.textColor = Color.gray100
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray500
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        addSubviews([phraseImageView,
                     dateLabel,
                     bookLabel,
                     lineView])
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(16)
        }
        
        phraseImageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(phraseImageView.snp.width)
        }
        
        bookLabel.snp.makeConstraints { make in
            make.top.equalTo(phraseImageView.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(phraseImageView.snp.trailing)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(bookLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Set Up Data
    
    func setupData(record: Record) {
        guard let name = record.store?.name,
              let title = record.title else { return }
        bookLabel.text = "|  🔖  \(name) \(title)"
        dateLabel.text = record.createdAt.toString()
    }
}

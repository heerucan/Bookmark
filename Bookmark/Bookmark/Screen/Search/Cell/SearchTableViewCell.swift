//
//  SearchTableViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

final class SearchTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    let storeLabel = UILabel().then {
        $0.font = Font.body2.font
        $0.textColor = Color.black100
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        contentView.addSubview(storeLabel)
        storeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Set Up Data
    
    func setupData(data: String) {
        storeLabel.text = data
    }
}

//
//  SettingCollectionViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import UIKit

final class SettingCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    private let cellLabel = UILabel().then {
        $0.font = Font.body5.font
        $0.textColor = Color.gray100
    }
    
    private let lineView = LineView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([cellLabel,
                                lineView])
        
        cellLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(21)
            make.leading.equalToSuperview().inset(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(cellLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Set Up Data
    
    func setupData(data: String) {
        cellLabel.text = data
    }
}

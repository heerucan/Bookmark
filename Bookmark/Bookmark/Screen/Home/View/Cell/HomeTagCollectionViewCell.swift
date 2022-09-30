//
//  HomeTagCollectionViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/18.
//

import UIKit

final class HomeTagCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    private var tagData = TagData()
    
    let tagLabel = UILabel().then {
        $0.textColor = Color.black100
        $0.font = Font.body7.font
    }
        
    var clickCount: Int = 0 {
        didSet {
            if clickCount == 0 {
                configureUnelectionStyle()
            } else {
                configureSelectionStyle()
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                configureSelectionStyle()
            } else {
                clickCount = 0
                configureUnelectionStyle()
            }
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        layer.cornerRadius = 19
        clipsToBounds = true
        backgroundColor = .white
    }
    
    override func configureLayout() {
        contentView.addSubviews([tagLabel])
        
        tagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(18)
        }
    }
    
    private func configureSelectionStyle() {
        tagLabel.textColor = Color.main
        tagLabel.font = Font.body6.font
    }
    
    private func configureUnelectionStyle() {
        tagLabel.textColor = Color.black100
        tagLabel.font = Font.body7.font
    }
    
    // MARK: - Set Up Data
    
    func setupData(index: Int) {
        tagLabel.text = tagData.getTagTitle(index: index)
    }
}

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
    
    private let tagLabel = UILabel().then {
        $0.textColor = Color.black100
        $0.font = Font.body4.font
    }
    
    private let tagImageView = UIImageView()
    
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
        layer.borderColor = Color.gray300.cgColor
        layer.cornerRadius = 38/2
        layer.borderWidth = 1
        clipsToBounds = true
        backgroundColor = .white
    }
    
    override func configureLayout() {
        contentView.addSubviews([tagLabel, tagImageView])
        tagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(14)
        }
        
        tagImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
        
    private func configureSelectionStyle() {
        tagLabel.textColor = Color.green100
        tagImageView.image = Icon.Image.like
        layer.borderColor = Color.green100.cgColor
    }
    
    private func configureUnelectionStyle() {
        tagLabel.textColor = Color.black100
        tagImageView.image = Icon.Image.unselectedLike
        layer.borderColor = Color.gray300.cgColor
    }
    
    // MARK: - Set Up Data
    
    func setupData(index: Int) {
        tagImageView.isHidden = (index != 0) ? true : false
        tagImageView.image = tagData.getTagImage(index: index)
        tagLabel.text = tagData.getTagTitle(index: index)
    }
}

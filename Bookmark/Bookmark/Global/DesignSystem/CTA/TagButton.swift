//
//  TagButton.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

class TagButton: UIButton {
    
    // MARK: - Enum
    
    enum ButtonType {
        case bookmark, category, location
        
        var font: UIFont? {
            switch self {
            case .bookmark:
                return nil
            case .category:
                return Font.body4.font
            case .location:
                return Font.body6.font
            }
        }
    }
    
    // MARK: - Property
    
    let tagLabel = UILabel().then {
        $0.font = Font.body4.font
    }
    
    let tagImageView = UIImageView().then {
        $0.image = Icon.Image.like
    }
    
    var isUnselected: Bool = true {
        didSet {
            tagLabel.textColor = isUnselected ? Color.black100 : Color.green100
            tagImageView.image = isUnselected ? Icon.Image.unselectedLike : Icon.Image.like
            layer.borderColor = isUnselected ? Color.gray300.cgColor : Color.green100.cgColor
        }
    }
    
    // MARK: - Initializer
    
    init(_ type: ButtonType) {
        super.init(frame: .zero)
        configureUI(type: type)
        configureLayout(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI(type: ButtonType) {
        layer.cornerRadius = (type == .location) ? 32/2 : 38/2
        layer.borderWidth = 1
        clipsToBounds = true
        backgroundColor = .white
    }
    
    private func configureLayout(type: ButtonType) {
        if type == .bookmark {
            self.addSubview(tagImageView)
            tagImageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(7)
                make.leading.trailing.equalToSuperview().inset(14)
            }
        } else {
            self.addSubview(tagLabel)
            tagLabel.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(8)
                make.leading.trailing.equalToSuperview().inset(14)
            }
        }
    }
}

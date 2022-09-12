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
        case category, location
        
        var font: UIFont {
            switch self {
            case .category:
                return Font.body4.font
            case .location:
                return Font.body6.font
            }
        }        
    }
    
    // MARK: - Property
    
    let tagLabel = UILabel()
    
    var isUnselected: Bool = true {
        didSet {
            tagLabel.textColor = isUnselected ? Color.black100 : Color.green100
            layer.borderColor = isUnselected ? Color.gray300.cgColor : Color.green100.cgColor
        }
    }
    
    // MARK: - Initializer
    
    init(_ type: ButtonType) {
        super.init(frame: .zero)
        configureUI(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI(type: ButtonType) {
        tagLabel.font = Font.body4.font
        layer.borderWidth = 1
        layer.cornerRadius = self.frame.width/2
        backgroundColor = .white
    }
    
    private func configureLayout() {
        self.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(14)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
}

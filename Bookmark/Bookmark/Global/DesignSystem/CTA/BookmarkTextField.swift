//
//  BookmarkTextField.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

class BookmarkTextField: UITextField {
    
    // MARK: - Property
    
    var isFocusing: Bool = false {
        didSet {
            layer.borderColor = isFocusing ?
            Color.black100.cgColor : Color.gray300.cgColor
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI() {
        textColor = Color.black100
        tintColor = Color.black100
        font = Font.body5.font
        backgroundColor = .white
        layer.borderWidth = 1
        addPadding()
        clearButtonMode = .whileEditing
        placeholder = "책 제목을 입력해주세요 (필수X)"
        guard let placeholder = placeholder else { return }
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: Color.gray300])
        
    }
    
    private func configureLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(43)
        }
    }
}

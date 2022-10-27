//
//  BookmarkTextField.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

final class BookmarkTextField: UITextField {
    
    // MARK: - Property
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ?
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
        placeholder = Matrix.textFieldPlaceholder
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

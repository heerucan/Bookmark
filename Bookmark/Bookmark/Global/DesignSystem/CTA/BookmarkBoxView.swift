//
//  BookmarkBoxView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/28.
//

import UIKit

final class BookmarkBoxView: BaseView {
    
    // MARK: - Property
    
    var text: String = ""
    
    let subLabel = UILabel()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        subLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        configureLabelStyle(label: subLabel)
        makeCornerStyle(width: 1, color: Color.gray400.cgColor, radius: 1)
    }
    
    override func configureLayout() {
        self.addSubview(subLabel)
        
        subLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(1)
            make.directionalHorizontalEdges.equalToSuperview().inset(9)
        }
    }
    
    // MARK: - Custom Method
    
    private func configureLabelStyle(label: UILabel) {
        label.font = Font.body8.font
        label.textColor = Color.gray100
        label.numberOfLines = 1
        label.textAlignment = .left
    }
}

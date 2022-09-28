//
//  BookCollectionReusableView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/23.
//

import UIKit

final class BookCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "BookCollectionReusableView"
    
    // MARK: - Property
    
    let titleLabel = UILabel().then {
        $0.text = "2022.09.12"
        $0.font = Font.body8.font
        $0.textColor = Color.gray100
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    func configureLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(16)
        }
    }
}

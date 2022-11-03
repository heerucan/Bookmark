//
//  BookSupplementaryView.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/31.
//

import UIKit

final class BookSupplementaryView: UICollectionReusableView {
    
    static let identifier = "BookSupplementaryView"
    
    // MARK: - Init
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        backgroundColor = Color.gray500
    }
}

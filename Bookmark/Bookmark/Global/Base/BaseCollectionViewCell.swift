//
//  BaseCollectionViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import SnapKit
import Then

class BaseCollectionViewCell: UICollectionViewCell, BaseMethodProtocol {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    func configureUI() { }
    func configureLayout() { }
}

//
//  BaseTableViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import SnapKit
import Then

class BaseTableViewCell: UITableViewCell {
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    func configureUI() { }
    func configureLayout() { }
}

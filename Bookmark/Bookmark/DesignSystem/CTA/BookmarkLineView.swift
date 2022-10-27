//
//  LineView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/28.
//

import UIKit

final class LineView: BaseView {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        backgroundColor = Color.gray500
    }
    
    override func configureLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}

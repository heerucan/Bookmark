//
//  BookmarkNavigationBar.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

final class BookmarkNavigationBar: BaseView {
    
    let titleLabel = UILabel().then {
        $0.font = Font.title1.font
        $0.textColor = Color.black100
        $0.textAlignment = .center
    }
    
    let backButton = UIButton().then {
        $0.setImage(Icon.Button.back, for: .normal)
    }
    
    let rightBarButton = UIButton().then {
        $0.setImage(Icon.Button.share, for: .normal)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray400
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([backButton, rightBarButton, lineView, titleLabel])
        
        backButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        rightBarButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(1)
        }
    }
}

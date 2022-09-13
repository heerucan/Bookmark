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
    
    let shareButton = UIButton().then {
        $0.setImage(Icon.Button.share, for: .normal)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray500
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func configureLayout() {
        self.addSubviews([backButton, shareButton, lineView, titleLabel])
        
        backButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        shareButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(backButton.snp.trailing).offset(82)
            make.trailing.equalTo(shareButton.snp.leading).offset(83)
            make.bottom.equalToSuperview().inset(10)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(1)
        }
    }
}

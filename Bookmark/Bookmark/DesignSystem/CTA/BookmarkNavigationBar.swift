//
//  BookmarkNavigationBar.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

final class BookmarkNavigationBar: BaseView {
    
    // MARK: - Enum
    
    enum NavigationType {
        case setting
        case detail
        case bookmark
        case write
        
        fileprivate var title: String {
            switch self {
            case .setting:
                return "Settings".localized
            case .bookmark, .write:
                return "writingNavigationTitle".localized
            case .detail:
                return ""
            }
        }
        
        fileprivate var rightButton: UIImage? {
            switch self {
            case .setting:
                return nil
            case .detail:
                return Icon.Button.share
            case .bookmark, .write:
                return Icon.Button.close
            }
        }
        
        fileprivate var leftButton: UIImage? {
            switch self {
            case .setting, .bookmark:
                return nil
            case .detail, .write:
                return Icon.Button.back
            }
        }
    }
    
    let titleLabel = UILabel().then {
        $0.font = Font.title1.font
        $0.textColor = Color.black100
        $0.textAlignment = .center
    }
    
    let leftButton = UIButton()
    let rightButton = UIButton()
    
    private let lineView = LineView()
    
    // MARK: - Initializer
    
    init(type: NavigationType) {
        super.init(frame: .zero)
        titleLabel.text = type.title
        leftButton.setImage(type.leftButton, for: .normal)
        rightButton.setImage(type.rightButton, for: .normal)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([leftButton,
                          rightButton,
                          lineView,
                          titleLabel])
        
        leftButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(1)
        }
    }
}

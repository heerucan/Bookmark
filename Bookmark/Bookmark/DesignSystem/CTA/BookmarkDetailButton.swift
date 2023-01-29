//
//  BookmarkDetailButton.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/28.
//

import UIKit

final class BookmarkDetailButton: UIButton {
    
    // MARK: - Enum
    
    enum InfoType {
        case homepage, phone, sns
        
        fileprivate var text: String {
            switch self {
            case .homepage:
                return "url".localized
            case .phone:
                return "phone".localized
            case .sns:
                return "sns".localized
            }
        }
        
        fileprivate var icon: UIImage? {
            switch self {
            case .homepage:
                return Icon.Image.homepage
            case .phone:
                return Icon.Image.phone
            case .sns:
                return Icon.Image.sns
            }
        }
    }
    
    // MARK: - Property
    
    var isDisabled: Bool = false {
        didSet {
            isUserInteractionEnabled = isDisabled ? false : true
            buttonLabel.textColor = isDisabled ? Color.gray300 : Color.black100
            iconView.tintColor = isDisabled ? Color.gray300 : Color.main
        }
    }
    
    private let buttonLabel = UILabel().then {
        $0.font = Font.body10.font
    }
    
    private let iconView = UIImageView()
    
    // MARK: - Initializer
    
    init(_ type: InfoType) {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
        buttonLabel.text = type.text
        iconView.image = type.icon
        configureImageColor(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI() {
        backgroundColor = Color.gray500
        iconView.tintColor = Color.main
    }
    
    private func configureLayout() {
        self.addSubviews([iconView, buttonLabel])
        
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        buttonLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    private func configureImageColor(type: InfoType) {
        let image = type.icon?.withRenderingMode(.alwaysTemplate)
        iconView.image = image
    }
}

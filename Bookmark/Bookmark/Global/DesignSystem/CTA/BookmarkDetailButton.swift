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
                return "홈페이지"
            case .phone:
                return "전화번호"
            case .sns:
                return "SNS"
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
            setDisabledImageColor()
        }
    }
    
    var isTouched: Bool = false {
        didSet {
            buttonLabel.textColor = isTouched ? Color.gray300 : Color.black100
            setHighlightedImageColor()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI() {
        backgroundColor = Color.gray500
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
    
    private func setDisabledImageColor() {
        if !isDisabled {
            iconView.tintColor = UIColor.clear
        } else {
            iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = Color.gray400
        }
    }
    
    private func setHighlightedImageColor() {
        if !isTouched {
            iconView.tintColor = Color.subMain
        } else {
            iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = UIColor.clear
        }
    }
}

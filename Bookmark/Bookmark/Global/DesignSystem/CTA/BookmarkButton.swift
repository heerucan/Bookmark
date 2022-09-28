//
//  BookmarkButton.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

import SnapKit
import Then

final class BookmarkButton: UIButton {
    
    // MARK: - Enum
    
    enum ButtonType {
        case complete, edit, bookmark
        
        fileprivate var text: String {
            switch self {
            case .complete:
                return "완료"
            case .edit:
                return "수정"
            case .bookmark:
                return "책갈피 꽂아두기"
            }
        }
    }
    
    // MARK: - Property
    
    var isDisabled: Bool = false {
        didSet {
            isUserInteractionEnabled = isDisabled ? false : true
            backgroundColor = isDisabled ? Color.gray400 : Color.black100
        }
    }
    
    // MARK: - Initializer
    
    init(_ type: ButtonType) {
        super.init(frame: .zero)
        configureUI(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI(type: ButtonType) {
        titleLabel?.font = Font.body3.font
        setTitle(type.text, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(Color.gray200, for: .highlighted)
        makeCornerStyle(width: 0, color: nil, radius: 5)
    }
}

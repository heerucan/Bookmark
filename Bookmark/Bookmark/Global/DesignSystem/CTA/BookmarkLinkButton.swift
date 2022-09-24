//
//  HyperLinkButton.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/18.
//

import UIKit

final class BookmarkLinkButton: UIButton {
    
    // MARK: - Enum
    
    enum LinkType {
        case phone, url
        
        fileprivate var color: UIColor {
            switch self {
            case .phone:
                return Color.gray100
            case .url:
                return Color.green100
            }
        }
    }
    
    // MARK: - Initializer
    
    init(_ type: LinkType) {
        super.init(frame: .zero)
        configureUI(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI(type: LinkType) {
        contentEdgeInsets = UIEdgeInsets(top: -1, left: 0, bottom: -1, right: 0)
        setTitleColor(Color.gray100, for: .normal)
        titleLabel?.font = Font.body7.font
        contentHorizontalAlignment = .left
    }
}

extension BookmarkLinkButton {
    func addLinkStyle(_ type: LinkType, range: String) {
        if let labelText = titleLabel?.text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.underlineColor, value: type.color,
                                          range: (labelText as NSString).range(of: range))
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue,
                                          range: (labelText as NSString).range(of: range))
            attributedString.addAttribute(.foregroundColor, value: type.color,
                                          range: (labelText as NSString).range(of: range))
            setAttributedTitle(attributedString, for: .normal)
        }
    }
}

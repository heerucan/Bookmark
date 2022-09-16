//
//  UILabel+.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

extension UILabel {
    func changeSearchTextColor(_ text: String?,
                               _ keyword: String,
                               color: UIColor = Color.green100) {
        guard let text = text else { return }
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSString(string: text).range(of: keyword, options: .caseInsensitive)
        let highlighteAttributes = [NSAttributedString.Key.foregroundColor: color]
        attributedText.addAttributes(highlighteAttributes, range: range)
        self.attributedText = attributedText
    }
    
    func addLinkStyle(color: UIColor, range: String) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.underlineColor, value: color, range: (labelText as NSString).range(of: range))
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: (labelText as NSString).range(of: range))
            attributedString.addAttribute(.foregroundColor, value: color, range: (labelText as NSString).range(of: range))
            attributedText = attributedString
        }
    }
}

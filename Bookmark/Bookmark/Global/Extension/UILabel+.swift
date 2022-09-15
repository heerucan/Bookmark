//
//  UILabel+.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

extension UILabel {
    func changeSearchTextColor(_ text: String?, _ keyword: String) {
        guard let text = text else { return }
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSString(string: text).range(of: keyword, options: .caseInsensitive)
        let highlighteAttributes = [NSAttributedString.Key.foregroundColor: Color.green100]
        attributedText.addAttributes(highlighteAttributes, range: range)
        self.attributedText = attributedText
    }
}

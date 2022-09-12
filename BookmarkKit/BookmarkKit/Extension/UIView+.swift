//
//  UIView+.swift
//  BookmarkKit
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

extension UIView {
    public func addSubviews(_ components: [UIView]) {
        components.forEach { self.addSubview($0) }
    }
    
    public func makeCornerStyle(_ width: CGFloat = 1,
                         _ color: CGColor,
                         _ radius: CGFloat = 5) {
        layer.borderWidth = width
        layer.borderColor = color
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

//
//  UIView+.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

extension UIView {
    func addSubviews(_ components: [UIView]) {
        components.forEach { self.addSubview($0) }
    }
    
    func makeCornerStyle(width: CGFloat = 1,
                         color: CGColor? = nil,
                         radius: CGFloat = 5) {
        layer.borderWidth = width
        layer.borderColor = color
        layer.cornerRadius = radius
    }
    
    func makeShadow(color: CGColor = Color.black100.cgColor,
                    radius: CGFloat,
                    offset: CGSize,
                    opacity: Float) {
        layer.shadowColor = color
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        clipsToBounds = false
    }
}

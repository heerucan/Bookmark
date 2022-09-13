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
        clipsToBounds = true
    }
    
//    shadowRadius : 블러의 정도 : 값이 커질수록 퍼짐
//    shadowOffset : 그림자의 위치 - CGSize
//    shadowOpacity : 그림자 모양 투명도 : 값이 커질수록 진해짐
//    shadowPath : 그림자모양 (커스텀이 가능)
    func makeShadow(radius: CGFloat, offset: CGSize, opacity: Float) {
        layer.shadowColor = Color.black100.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
}

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
                         radius: CGFloat = 1) {
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
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width/2-141.5,
                                               y: 550,
                                               width: 283,
                                               height: 47)).then {
            $0.backgroundColor = Color.black100.withAlphaComponent(0.89)
            $0.textColor = .white
            $0.font = Font.body5.font
            $0.textAlignment = .center
            $0.text = message
            $0.layer.cornerRadius = 47/2
            $0.clipsToBounds  =  true
            self.addSubview($0)
        }
        
        UIView.animate(withDuration: 2, delay: 0.2, options: .curveEaseIn) {
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   actions: [UIAlertAction] = [],
                   preferredStyle: UIAlertController.Style = .actionSheet) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actions.forEach { alert.addAction($0) }
        alert.addAction(cancel)
    }
    
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

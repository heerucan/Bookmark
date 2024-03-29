//
//  UITextField+.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

extension UITextField {
    func addPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.rightView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightViewMode = ViewMode.always
    }
}

//
//  String+.swift
//  Bookmark
//
//  Created by heerucan on 2023/01/29.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized<T>(with: T) -> String {
        return String(format: self.localized, with as! CVarArg)
    }
}

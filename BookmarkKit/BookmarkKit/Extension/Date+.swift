//
//  Date+.swift
//  BookmarkKit
//
//  Created by heerucan on 2022/09/12.
//

import Foundation

extension Date {
    public func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
}

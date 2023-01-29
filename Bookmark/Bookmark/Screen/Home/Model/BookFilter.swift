//
//  BookFilter.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/21.
//

import Foundation

enum BookFilter: Int {
    case new = 0
    case old
    case all
//    case bookmark = 3
    
    var typeNo: String? {
        switch self {
        case .new:
            return Matrix.new
        case .old:
            return Matrix.old
        case .all:
            return nil
        }
    }
    
    var name: String {
        switch self {
        case .new:
            return "new".localized
        case .old:
            return "old".localized
        case .all:
            return "전체"
        }
    }
}

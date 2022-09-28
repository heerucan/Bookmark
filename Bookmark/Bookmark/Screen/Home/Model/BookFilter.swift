//
//  BookFilter.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/21.
//

import Foundation

enum BookFilter: Int {
    case new = 0
    case old = 1
    case all = 2
    case bookmark = 3
    
    var typeNo: String? {
        switch self {
        case .new:
            return Matrix.new
        case .old:
            return Matrix.old
        case .all, .bookmark:
            return nil
        }
    }
}

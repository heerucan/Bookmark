//
//  Setting.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

@frozen
enum Setting: Int, CaseIterable {
    case help
    case about

    var menu: [String] {
        switch self {
        case .help:
            return ["contact".localized, "review".localized]
        case .about:
            return ["aboutBookmark".localized]
        }
    }
}

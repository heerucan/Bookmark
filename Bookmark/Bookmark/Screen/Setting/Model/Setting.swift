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
    case manage
    case about

    var menu: [String] {
        switch self {
        case .help:
            return ["문의하기", "리뷰 남기기"]
        case .manage:
            return ["백업하기", "복구하기"]
        case .about:
            return ["책갈피 소개"]
        }
    }
}

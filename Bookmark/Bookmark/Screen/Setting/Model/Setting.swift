//
//  Setting.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

@frozen
enum Setting: CaseIterable {
    case first
    case second
    case third

    var menu: [String] {
        switch self {
        case .first:
            return ["문의하기", "리뷰 남기기"]
        case .second:
            return ["백업하기", "복구하기"]
        case .third:
            return ["책갈피 소개"]
        }
    }
}

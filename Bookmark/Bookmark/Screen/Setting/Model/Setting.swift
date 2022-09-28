//
//  Setting.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

enum Setting: CaseIterable, CustomStringConvertible {
    case notice
    case fileManage
    case aboutBookmark
    
    var description: String {
        switch self {
        case .notice:
            return "공지"
        case .fileManage:
            return "개인"
        case .aboutBookmark:
            return "기타"
        }
    }
    
    var menu: [String] {
        switch self {
        case .notice:
            return ["책갈피 색변경하기", "문의하기", "리뷰 남기기"]
        case .fileManage:
            return ["백업하기", "복구하기"]
        case .aboutBookmark:
            return ["책갈피 소개", "버전 1.0.0"]
        }
    }
    
    var numberOfRowInSection: Int {
        return menu.count
    }
}

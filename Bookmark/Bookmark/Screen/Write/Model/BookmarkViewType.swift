//
//  FromWhatView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

// MARK: - Enum

enum FromWhatView {
    case detail
    case bookmark
    
    // 책갈피 꽂아두기에서 뒤로가기 / 엑스버튼 관련 부분
    var leftButtonIsHidden: Bool {
        switch self {
        case .detail:
            return false
        case .bookmark:
            return true
        }
    }
    
    var rightButtonIsHidden: Bool {
        switch self {
        case .detail:
            return true
        case .bookmark:
            return false
        }
    }
}

enum ViewType {
    case write
    case edit
}

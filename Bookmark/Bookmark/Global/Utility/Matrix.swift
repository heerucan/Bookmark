//
//  Matrix.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/15.
//

import Foundation

enum Matrix {
    
    // 카테고리 Bool 값
    static let phraseCategory = true
    static let bookCategory = false
    
    // cell 값
    static let markerWidth = 22.0
    static let markerHeight = 35.0
    static let cellWidth = 74
    static let cellHeight = 37
    static let cellMargin = 10.0
    static let cellSpacing = 8.0
    
    // key값
    static let new = "0002"
    static let old = "0001"
    
    // 팝업 메시지 & 문자열
    static let settingMessage = "settingMessage".localized
    static let backPopupTitle = "backPopupTitle".localized
    static let backPopupMessage = "backPopupMessage".localized
    static let sentence = "writingSubTitle".localized
    static let book = "bookSubTitle".localized
    static let textFieldPlaceholder = "titlePlaceHolder".localized
    static let clipboard = "clipBoardToast".localized
    static let writeInfoText = "imageModifyMessage".localized
    
    enum Network {
        static let title = "networkTitle".localized
        static let subtitle = "networkSubTitle".localized
        static let button = "networkButton".localized
    }
}

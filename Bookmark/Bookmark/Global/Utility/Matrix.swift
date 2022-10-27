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
    
    // 팝업 메시지
    static let settingMessage = "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요."
    static let backPopupTitle = "완료하지 않고 나갈 건가요?"
    static let backPopupMessage = "기록한 책갈피는 저장되지 않아요!"
    static let sentence = "공감 가는 글을 꽂아두세요"
    static let book = "사고 싶은 책을 꽂아두세요"
    static let textFieldPlaceholder = "책 제목은 필수가 아니에요 :)"
    static let clipboard = "클립보드에 책방 주소가 복사됐어요!"
}

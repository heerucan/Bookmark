//
//  Font.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

struct FontProperty {
    let font: UIFont
    let kern: CGFloat
    let lineHeight: CGFloat?
}

enum BookmarkFont {
    case title1
    case body1
    case body2
    case body3
    case body4
    case body5
    case body6
    case body7
    case body8
    
    var property: FontProperty {
        switch self {
        case .title1:
            return FontProperty(font: UIFont(name: "", size: <#T##CGFloat#>), kern: <#T##CGFloat#>, lineHeight: <#T##CGFloat?#>)
        case .body1:
            <#code#>
        case .body2:
            <#code#>
        case .body3:
            <#code#>
        case .body4:
            <#code#>
        case .body5:
            <#code#>
        case .body6:
            <#code#>
        case .body7:
            <#code#>
        case .body8:
            <#code#>
        }
    }
}

extension BookmarkFont {
    
}

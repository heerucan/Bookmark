//
//  WriteViewState.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import UIKit

// MARK: - Enum

enum WriteViewState {
    case sentence
    case book
    
    var description: String {
        switch self {
        case .sentence:
            return Matrix.sentence
        case .book:
            return Matrix.book
        }
    }
    
    var imageButtonOffset: Int {
        switch self {
        case .sentence:
            return 88
        case .book:
            return 25
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .sentence:
            return false
        case .book:
            return true
        }
    }
}

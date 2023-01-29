//
//  Tag.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/18.
//

import UIKit

struct Tag {
    let title: String?
}

struct TagData {
    var tagArray = [
//        Tag(title: "책갈피"),
        Tag(title: "new".localized),
        Tag(title: "old".localized)
    ]

    func getTagCount() -> Int {
        return tagArray.count
    }
    
    func getTagTitle(index: Int) -> String {
        return tagArray[index].title!
    }
}

//
//  Tag.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/18.
//

import UIKit

struct Tag {
    let title: String?
    let image: UIImage?
}

struct TagData {
    var tagArray = [
        Tag(title: nil, image: Icon.Image.unselectedLike),
        Tag(title: "새책방", image: nil),
        Tag(title: "헌책방", image: nil)
    ]
    
    func getTagCount() -> Int {
        return tagArray.count
    }
    
    func getTagTitle(index: Int) -> String? {
        guard let title = tagArray[index].title else { return nil }
        return title
    }
    
    func getTagImage(index: Int) -> UIImage? {
        return tagArray[index].image
    }
    
//    func getTagSelection(index: Int) -> Bool {
//        return tagArray[index].select
//    }
}

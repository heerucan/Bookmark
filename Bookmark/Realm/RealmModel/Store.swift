//
//  BookStore.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

import RealmSwift

// MARK: - Store

class Store: Object {
    @Persisted var name: String
    @Persisted var bookmark: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(name: String,
                     bookmark: Bool) {
        self.init()
        self.name = name
        self.bookmark = bookmark
    }
}

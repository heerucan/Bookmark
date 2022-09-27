//
//  BookmarkRealmModel.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

import RealmSwift

// MARK: - Store

final class Store: Object {
    @Persisted(indexed: true) var name = ""
    @Persisted var bookmark: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
            
    convenience init(name: String, bookmark: Bool) {
        self.init()
        self.name = name
        self.bookmark = bookmark
    }
}

// MARK: - Record

final class Record: Object {
    @Persisted var store: Store?
    @Persisted var title: String?
    @Persisted var category: Bool
    @Persisted var createdAt = Date()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(store: Store?, title: String?, category: Bool, createdAt: Date) {
        self.init()
        self.store = store
        self.title = title
        self.category = category
        self.createdAt = createdAt
    }
}

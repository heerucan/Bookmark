//
//  Record.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

import RealmSwift

// MARK: - Record

final class Record: Object {
    @Persisted var store: Store?
    @Persisted var title: String?
    @Persisted var image: String?
    @Persisted var category: Bool
    @Persisted var createdAt = Date()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(store: Store,
                     title: String?,
                     image: String?,
                     category: Bool,
                     createdAt: Date) {
        self.init()
        self.store = Store()
        self.title = title
        self.image = image
        self.category = category
        self.createdAt = createdAt
    }
}

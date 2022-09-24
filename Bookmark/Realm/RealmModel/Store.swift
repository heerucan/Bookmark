//
//  BookStore.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

import RealmSwift

// MARK: - Store

final class Store: Object {
    @Persisted var name: String
    @Persisted var bookmark: Bool
    @Persisted var record: List<Record>
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(name: String, bookmark: Bool, record: List<Record>) {
        self.init()
        self.name = name
        self.bookmark = bookmark
        self.record = record
    }
}

// MARK: - Record

final class Record: Object {
    @Persisted var title: String?
    @Persisted var category: Category
    @Persisted var createdAt = Date()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String?, category: Category, createdAt: Date) {
        self.init()
        self.title = title
        self.category = category
        self.createdAt = createdAt
    }
}

// MARK: - Category

final class Category: Object {
    @Persisted var title: String
    @Persisted var isSelected: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, isSelected: Bool) {
        self.init()
        self.title = title
        self.isSelected = false
    }
}

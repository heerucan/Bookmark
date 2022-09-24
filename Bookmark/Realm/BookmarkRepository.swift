//
//  BookmarkRepository.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

import RealmSwift

protocol BookmarkRepositoryType {
    
    // 1. 글추가
    func addRecord(item: Record)
    
    // 2. 글삭제
    func deleteRecord(item: Record)
    
    // 3. 글수정
    func updateRecord(item: Any?)
    
    // 4. 책방 북마크추가-해제
    func updateBookmark(item: Store)
    
    // 5. 지도 북마크필터
    func updateBookmarkFilter(item: Store) -> Results<Store>
    
    // 6. 책갈피탭 초기 정렬
    func fetchRecord(_ item: String) -> Results<Record>
}

class BookmarkRepository: BookmarkRepositoryType {

    var realm = try! Realm()
    
    func addRecord(item: Record) {
        do {
            try realm.write {
                realm.add(item)
                print("Create Realm 성공!")
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteRecord(item: Record) {
        do {
            try realm.write {
                realm.delete(item)
                print("Delete Realm 성공!")
            }
//            FileManagerHelper.shared.removeImageFromDocument(fileName: "\(item.objectId).jpg")
        } catch let error {
            print(error)
        }
    }
    
    func updateRecord(item: Any?) {
        do {
            try realm.write {
                realm.create(Record.self, value: item as Any, update: .modified)
                print("Update Realm 성공!")
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateBookmark(item: Store) {
        do {
            try realm.write {
                item.bookmark = !item.bookmark
                print("Bookmark value - \(item.bookmark) 변경 성공!")
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateBookmarkFilter(item: Store) -> Results<Store> {
        return realm.objects(Store.self).filter("bookmark == \(item.bookmark)")
    }
    
    func fetchRecord(_ item: String) -> Results<Record> {
        return realm.objects(Record.self).sorted(byKeyPath: "createdAt", ascending: false).filter("category == \(item)")
    }
}

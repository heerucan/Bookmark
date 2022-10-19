//
//  BookmarkRepository.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/22.
//

import Foundation

import RealmSwift

// MARK: - BookmarkRepositoryType

protocol BookmarkRepositoryType {
    
    // 0. 책갈피탭 초기 정렬
    func fetchRecord(_ item: String) -> Results<Record>
    
    // 1. 글추가
    func addRecord(item: Record)
    
    // 2. 글수정
    func updateRecord(item: Any?)
    
    // 3. 글삭제
    func deleteRecord(item: Record)
        
    // 4. 책방 북마크 초기 정렬
    func fetchBookmark() -> Results<Store>
    
    // 5. 책방 북마크 추가-해제
    func updateBookmark(item: Any?)
    
    func fetchBookmark(item: String) -> Results<Store>
}

// MARK: - BookmarkRepository

final class BookmarkRepository {
    static let shared = BookmarkRepository()
    private init() { }
    
    var realm = try! Realm()
    
    // MARK: - Record
    
    func fetchRecord() -> Results<Record> {
        return realm.objects(Record.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    func fetchRecord(_ item: String) -> Results<Record> {
        return realm.objects(Record.self).sorted(byKeyPath: "createdAt", ascending: false).filter("category == \(item)")
    }
    
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
    
    func deleteRecord(item: Record) {
        do {
            try realm.write {
                FileManagerHelper.shared.removeImageFromDocument(fileName: "\(item.objectId).jpg")
                realm.delete(item)
                print("Delete Realm 성공!")
            }
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - Bookmark
    
    func fetchBookmark() -> Results<Store> {
        return realm.objects(Store.self).sorted(byKeyPath: "bookmark", ascending: true)
    }
    
    func fetchBookmark(item: String) -> Results<Store> {
        return realm.objects(Store.self).filter("name == \(item)")
    }
    
    // MARK: - true인 애들만 따로 배열로 뽑아서 거기에 home 지도 상에 선택한 마커의 서점 이름과 재도시에 같은 아이로 반환
    
    func updateBookmark(item: Any?) {
        do {
            try realm.write {
                realm.create(Store.self, value: item as Any, update: .modified)
                print("Update Bookmark 성공!", item as Any)
            }
        } catch let error {
            print(error)
        }
    }
    
    // 문제 업데이트인데 이게 계속 생성되는 게 문제였음
    func updateBookmark(item: Store) {
        do {
            try realm.write {
                item.bookmark = !item.bookmark
//                realm.create(Store.self, value: item as Any, update: .modified)
                print("Update Bookmark 성공!", item as Any)
            }
        } catch let error {
            print(error)
        }
    }
}

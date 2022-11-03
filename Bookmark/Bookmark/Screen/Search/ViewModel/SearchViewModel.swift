//
//  SearchViewModel.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/28.
//

import Foundation

import RxSwift

final class SearchViewModel {
    var filterList: [BookStoreInfo] = []
    
    let bookstoreList = PublishSubject<[BookStoreInfo]>()
//    let bookstoreList = BehaviorSubject<[BookStoreInfo]>(value: [BookStoreInfo(name: "",
//                                                                               district: "",
//                                                                               address: "",
//                                                                               phone: "",
//                                                                               homeURL: "",
//                                                                               typeNo: "",
//                                                                               typeName: "",
//                                                                               latitude: "",
//                                                                               longtitude: "",
//                                                                               sns: "")])
//
    
    func requestBookStore(_ endIndex: Int = 1000) {
        StoreAPIManager.shared.fetchBookStore(endIndex: endIndex) { [weak self] (data, status, error) in
            guard let self = self,
                  let data = data else { return }
            self.bookstoreList.onNext(data.total.info)
        }
    }
    
    func filterBookStore(text: String) {
        if text.isEmpty {
            self.bookstoreList.onNext(filterList)
        } else {
            let result = filterList.filter { $0.name.contains(text) }
            self.bookstoreList.onNext(result)
        }
    }
}

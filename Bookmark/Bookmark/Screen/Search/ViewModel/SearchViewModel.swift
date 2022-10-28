//
//  SearchViewModel.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/28.
//

import Foundation

import RxSwift

final class SearchViewModel {
    
    let filterredList = PublishSubject<BookStoreInfo>()
    let bookstoreList = PublishSubject<BookStoreInfo>()
    
    
}

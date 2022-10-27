//
//  StoreAPIManager.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import Foundation

import Alamofire

final class StoreAPIManager {
    private init() { }
    static let shared = StoreAPIManager()
    
    typealias Completion = ((BookStore?, Int?, Error?) -> Void)
    
    // MARK: - GET : BookStore
    
    func fetchBookStore(endIndex: Int, completion: @escaping Completion) {
        AF.request(StoreRouter.bookStore(endIndex: endIndex))
            .validate(statusCode: 200..<500)
            .responseDecodable(of: BookStore.self) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value):
                completion(value, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
}

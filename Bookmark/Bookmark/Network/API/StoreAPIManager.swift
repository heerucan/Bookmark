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
    
    typealias completion = ((BookStore?, Int?, Error?) -> Void)
    
    // MARK: - GET : BookStore
    
    func fetchBookStore(completion: @escaping completion) {
        AF.request(StoreRouter.bootStore).validate(statusCode: 200..<500).responseDecodable(of: BookStore.self) { response in
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

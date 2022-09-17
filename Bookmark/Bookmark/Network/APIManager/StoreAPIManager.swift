//
//  StoreAPIManager.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import Foundation

struct StoreAPIManager {
    private init() { }
    static let shared = StoreAPIManager()
    
    func fetchBookStore(completion: @escaping (BookStore?, APIError?) -> Void) {
        guard let url = EndPoint.seoul.makeURL() else { return }       
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("요청 실패")
                completion(nil, .failedRequest)
                return
            }

            guard let data = data else {
                print("반환된 데이터 없음")
                completion(nil, .noData)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("잘못된 응답")
                completion(nil, .invalidResponse)
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                print("응답 실패")
                completion(nil, .failedRequest)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(BookStore.self, from: data)
                completion(result, nil)
            } catch {
                print(error)
                completion(nil, .invalidData)
            }
        }.resume()
    }
}

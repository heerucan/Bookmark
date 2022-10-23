//
//  StoreRouter.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/23.
//

import Foundation

import Alamofire

@frozen
enum StoreRouter {
    case bootStore
}

extension StoreRouter: URLRequestConvertible {
    private var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }
    
    private var method: HTTPMethod {
        switch self {
        case .bootStore:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .bootStore:
            // MARK: - FIX endIndex로 변경
            return "/\(APIKey.bookStoreAccessKey)/json/TbSlibBookstoreInfo/1/613"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        return request
    }
}

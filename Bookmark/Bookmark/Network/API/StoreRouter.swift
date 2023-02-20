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
    case bookStore(endIndex: Int)
}

extension StoreRouter: URLRequestConvertible {
    private var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }
    
    private var method: HTTPMethod {
        switch self {
        case .bookStore:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .bookStore(let endIndex):
            return "/\(APIConstant.bookStoreAccessKey)/json/TbSlibBookstoreInfo/1/\(endIndex)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        return request
    }
}

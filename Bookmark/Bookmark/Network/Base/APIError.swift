//
//  APIError.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
    case serverError
}

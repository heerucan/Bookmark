//
//  BookStore.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/15.
//

import Foundation

// MARK: - BookStore

struct BookStore: Codable {
    let total: BookStoreTotal

    enum CodingKeys: String, CodingKey {
        case total = "TbSlibBookstoreInfo"
    }
}

// MARK: - BookStoreInfo

struct BookStoreTotal: Codable {
    let totalCount: Int
    let result: Result
    let info: [BookStoreInfo]

    enum CodingKeys: String, CodingKey {
        case totalCount = "list_total_count"
        case result = "RESULT"
        case info = "row"
    }
}

// MARK: - Result

struct Result: Codable {
    let code, message: String

    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

// MARK: - BookStoreInfo

struct BookStoreInfo: Codable {
    let storeId: Float
    let name, district, address, phone: String
    let homeURL, typeNo, typeName, latitude, longtitude: String
    let sns: String

    enum CodingKeys: String, CodingKey {
        case storeId = "STORE_SEQ_NO"
        case name = "STORE_NAME"
        case district = "CODE_VALUE"
        case address = "ADRES"
        case phone = "TEL_NO"
        case homeURL = "HMPG_URL"
        case typeNo = "STORE_TYPE"
        case typeName = "STORE_TYPE_NAME"
        case latitude = "XCNTS"
        case longtitude = "YDNTS"
        case sns = "SNS"
    }
}

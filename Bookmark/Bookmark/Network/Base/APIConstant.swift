//
//  APIConstant.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/23.
//

import Foundation

enum APIConstant {
    static let baseURL = "http://openapi.seoul.go.kr:8088"
    static let bookStoreAccessKey = Bundle.main.object(forInfoDictionaryKey: "BOOKSTORE_API_KEY")
    static let clientId = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID")
    static let bundleName = Bundle.main.object(forInfoDictionaryKey: "BUNDLE_NAME")
    static let notion = Bundle.main.object(forInfoDictionaryKey: "NOTION")
    static let ask = Bundle.main.object(forInfoDictionaryKey: "ASK_NOTION")
    static let introduce = Bundle.main.object(forInfoDictionaryKey: "INTRODUCE_NOTION")
    static let myAppId = Bundle.main.object(forInfoDictionaryKey: "MY_APP_ID")
}

//
//  APIConstant.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/23.
//

import Foundation

enum APIConstant {
    static let baseURL = "http://openapi.seoul.go.kr:8088/"
    static let clientId = "ezmxtxc1hy"
    static let notion = "https://huree-can-do-it.notion.site/a81bf0e5cd70490aafd626fed190fc4b"
    static let ask = "https://huree-can-do-it.notion.site/85628a54ec75423089def1b50bfc17d7"
    static let introduce = "https://huree-can-do-it.notion.site/a81bf0e5cd70490aafd626fed190fc4b"
    static let myAppId = "https://apps.apple.com/app/id1645004700"
    
    static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("📛 not Found")
        }
        return dict
    }()

    static let bookStoreAccessKey: String = {
        guard var bookStoreAccessKeyString = APIConstant.infoDictionary["BOOKSTORE_API_KEY"] as? String else {
            fatalError("📛 bookStoreAccessKeyString not Found")
        }
        return bookStoreAccessKeyString
    }()
    
    static let bundleName: String = {
        guard let bundleNameString = APIConstant.infoDictionary["BUNDLE_NAME"] as? String else {
            fatalError("📛 bundleNameString not Found")
        }
        return bundleNameString
    }()
}

//
//  EndPoint.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import Foundation

enum EndPoint {
    case seoul
    case naver
    case appstore
    case phone
    case safari
    
    func makeURL(_ path: String? = nil) -> URL? {
        switch self {
        case .seoul:
            let seoul = "http://openapi.seoul.go.kr:8088/\(APIKey.seoul)/json/TbSlibBookstoreInfo/1/613"
            return URL(string: seoul)
        case .naver:
            guard let search = path?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            let naver = "nmap://search?query=\(String(describing: search))&appname=\(APIKey.bundleName)"
            return URL(string: naver)
        case .appstore:
            let appStore =  "https://apps.apple.com/kr/app/%EB%84%A4%EC%9D%B4%EB%B2%84-%EC%A7%80%EB%8F%84-%EB%82%B4%EB%B9%84%EA%B2%8C%EC%9D%B4%EC%85%98/id311867728"
            return URL(string: appStore)
        case .phone:
            guard let number = path else { return nil }
            let phone = "tel://" + number
            guard let phoneURL = NSURL(string: phone) as URL? else { return nil }
            return phoneURL
        case .safari:
            guard let pageLink = path else { return nil }
            guard let safariURL = NSURL(string: pageLink) as URL? else { return nil }
            return safariURL
        }
    }
}

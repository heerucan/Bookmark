//
//  EndPoint.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import Foundation

@frozen
enum EndPoint {
    case naver
    case kakao
    case google
    case phone
    case safari
    case notion
    case ask
    case instagram
    
    func makeURL(_ path: String? = nil) -> URL? {
        switch self {
        case .naver:
            guard let search = path?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            let naver = "nmap://search?query=\(String(describing: search))&appname=\(APIKey.bundleName)"
            return URL(string: naver)
        case .kakao:
            guard let number = path else { return nil }
            let kakao = "kakaomap://look?p=\(number)"
            return  URL(string: kakao)
        case .google:
            guard let number = path else { return nil }
            let google = "comgooglemaps://?center=\(number)&zoom=14"
            return  URL(string: google)
        case .phone:
            guard let number = path else { return nil }
            let phone = "tel://" + number
            guard let phoneURL = NSURL(string: phone) as URL? else { return nil }
            return phoneURL
        case .safari:
            guard let pageLink = path else { return nil }
            guard let safariURL = NSURL(string: pageLink) as URL? else { return nil }
            return safariURL
        case .notion:
            guard let notionURL = NSURL(string: APIKey.notion) as URL? else { return nil }
            return notionURL
        case .ask:
            guard let askURL = NSURL(string: APIKey.ask) as URL? else { return nil }
            return askURL
        case .instagram:
            let instagramURL = "instagram-stories://share"
            return URL(string: instagramURL)
        }
    }
}

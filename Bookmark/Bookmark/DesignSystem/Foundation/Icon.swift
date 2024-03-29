//
//  Constant.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

enum Icon {

    static let marker = "icnMarker"
    static let bookMarker = "icnBookmarkMarker"
    static let selectedMarker = "icnSelectedMarker"
    
    enum TabBar {
        static let map = UIImage(named: "icnMap")
        static let unselectedMap = UIImage(named: "icnUnselectedMap")
        static let bookmark = UIImage(named: "icnBookmark")
        static let unselectedBookmark = UIImage(named: "icnUnselectedBookmark")
        static let setting = UIImage(named: "icnSetting")
        static let unselectedSetting = UIImage(named: "icnUnselectedSetting")
    }
    
    enum Button {
        static let back = UIImage(named: "btnBack")
        static let clone = UIImage(named: "btnClone")
        static let write = UIImage(named: "btnWrite")
        static let share = UIImage(named: "btnShare")
        static let myLocation = UIImage(named: "btnMyLocation")
        static let highlightedMyLocation = UIImage(named: "btnSelectedMyLocation")
        static let goMapApp = UIImage(named: "btnGoMapApp")
        static let highlightedGoMapApp = UIImage(named: "btnHighlightedGoMapApp")
        static let unselectedBookmark = UIImage(named: "btnDetailUnselectedLike")
        static let bookmark = UIImage(named: "btnDetailLike")
        static let close = UIImage(named: "btnClose")
        static let more = UIImage(named: "btnMore")
    }
    
    enum Image {
        static let emptyState = UIImage(named: "imgEmptyState")
        static let search = UIImage(named: "icnSearch")
        static let unselectedLike = UIImage(named: "icnUnselectedLike")
        static let gallery = UIImage(named: "icnImage")
        static let phone = UIImage(named: "icnPhone")
        static let homepage = UIImage(named: "icnDetailSearch")
        static let sns = UIImage(named: "icnLink")
    }

    enum Logo {
        static let white = UIImage(named: "imgSplashWhite")
        static let red = UIImage(named: "imgLogo")
    }
}

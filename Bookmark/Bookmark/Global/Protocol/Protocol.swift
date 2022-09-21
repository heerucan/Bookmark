//
//  Protocol.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/18.
//

import SafariServices

protocol SafariViewDelegate: DetailViewController {
    func presentSafariView(_ safariView: SFSafariViewController)
}

//
//  Protocol.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/18.
//

import SafariServices

protocol BaseMethodProtocol {
    func configureUI()
    func configureLayout()
}

protocol SafariViewDelegate: DetailViewController {
    func presentSafariView(_ safariView: SFSafariViewController)
}


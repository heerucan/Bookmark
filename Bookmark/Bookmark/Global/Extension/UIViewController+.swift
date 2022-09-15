//
//  UIViewController+.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?,
                   message: String?,
                   actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actions.forEach { alert.addAction($0) }
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

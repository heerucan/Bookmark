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
                   actions: [UIAlertAction],
                   cancelTitle: String? = "취소",
                   preferredStyle: UIAlertController.Style = .actionSheet) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
        actions.forEach { alert.addAction($0) }
        alert.addAction(cancel)
        transition(alert, .present)
    }
    
    func showActivity(activityItems: [Any]) {
        let viewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        transition(viewController, .present)
    }
}

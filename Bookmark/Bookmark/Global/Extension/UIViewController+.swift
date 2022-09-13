//
//  UIViewController+.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

extension UIViewController {
    typealias completion = ((UIAlertAction) -> Void)?
    
    func showAlert(handler: completion, secondHander: completion) {
        let alertViewController = UIAlertController(title: "어떤 책갈피를 꽂으실 건가요?", message: nil, preferredStyle: .actionSheet)
        let firstAlertAction = UIAlertAction(title: "공감 가는 글 한 줄", style: .default, handler: handler)
        let secondAlertAction = UIAlertAction(title: "공감 가는 책 한 권", style: .default, handler: secondHander)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertViewController.addAction(firstAlertAction)
        alertViewController.addAction(secondAlertAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
    }
}

//
//  UIViewController+.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

extension UIViewController {
    typealias completion = ((UIAlertAction) -> Void)?
    
    func showAlert(_ firstHandler: completion, _ secondHandler: completion) {
        let alertViewController = UIAlertController(title: "어떤 책갈피를 꽂으실 건가요?", message: nil, preferredStyle: .actionSheet)
        let firstAlertAction = UIAlertAction(title: "공감 가는 글 한 줄", style: .default, handler: firstHandler)
        let secondAlertAction = UIAlertAction(title: "공감 가는 글 한 줄", style: .default, handler: secondHandler)
        alertViewController.addAction(firstAlertAction)
        alertViewController.addAction(secondAlertAction)
        present(alertViewController, animated: true, completion: nil)
    }
}

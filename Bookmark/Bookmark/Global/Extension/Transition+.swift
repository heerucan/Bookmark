//
//  Transition+.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/18.
//

import UIKit

extension UIViewController {
    enum TransitionStyle {
        case presentNavigation
        case present
        case presentedViewDismiss
        case push
        case dismiss
        case pop
    }
    
    func transition<T: UIViewController>(_ viewController: T,
                                         _ style: TransitionStyle = .push,
                                         completion: ((T) -> Void)? = nil) {
        completion?(viewController)
        switch style {
        case .presentNavigation:
            let navigation = UINavigationController(rootViewController: viewController)
            viewController.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true)
        case .present:
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        case .presentedViewDismiss:
            self.dismiss(animated: true) {
                viewController.viewWillAppear(true)
            }
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .dismiss:
            self.dismiss(animated: true)
        case .pop:
            navigationController?.popViewController(animated: true)
        }
    }
}

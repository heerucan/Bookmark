//
//  BaseViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import SnapKit
import Then

class BaseViewController: UIViewController, BaseMethodProtocol {
    
    // MARK: - Property
    
    var keyboardHeight: CGFloat = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        setupDelegate()
        bindData()
        setupNotificationCenter()
    }

    // MARK: - Configure UI & Layout
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureLayout() { }
    func setupDelegate() { }
    
    // MARK: - Bind Data
    
    func bindData() { }
    
    // MARK: - Keyboard
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
    
    // MARK: - @objc
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
}

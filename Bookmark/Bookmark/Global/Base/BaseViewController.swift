//
//  BaseViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import SnapKit
import Then

class BaseViewController: UIViewController {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }

    // MARK: - Configure UI & Layout
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureLayout() { }
}

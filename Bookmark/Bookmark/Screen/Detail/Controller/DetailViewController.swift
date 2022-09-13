//
//  DetailViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    // MARK: - Property
    
    let detailView = DetailView()
        
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure UI & Layout
    
    // MARK: - Custom Method
    
    private func setupAction() {
        detailView.writeButton.addTarget(self, action: #selector(touchupWriteButton), for: .touchUpInside)
    }
    
    
    // MARK: - @objc
    
    @objc func touchupWriteButton() {
        let viewController = WriteViewController()
        showAlert { _ in
            viewController.viewType = .sentence
        } _: { _ in
            viewController.viewType = .book
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

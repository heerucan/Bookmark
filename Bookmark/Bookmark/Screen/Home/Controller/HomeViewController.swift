//
//  HomeViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    // MARK: - Property
    
    private let homeView = HomeView()
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func configureLayout() {
        super.configureLayout()
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Custom Method
    
    private func setupAction() {
        homeView.transitionButton.addTarget(self, action: #selector(touchupTransitionButton), for: .touchUpInside)
        homeView.storeButton.addTarget(self, action: #selector(touchupStoreButton), for: .touchUpInside)
        homeView.bookmarkButton.addTarget(self, action: #selector(touchupTagButton(_:)), for: .touchUpInside)
        homeView.newStoreButton.addTarget(self, action: #selector(touchupTagButton(_:)), for: .touchUpInside)
        homeView.oldStoreButton.addTarget(self, action: #selector(touchupTagButton(_:)), for: .touchUpInside)
    }
    
    // MARK: - @objc
    
    @objc func touchupTagButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc func touchupTransitionButton() {
        let viewController = SearchViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func touchupStoreButton() {
        let viewController = DetailViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4) {
            self.homeView.storeButton.transform = CGAffineTransform(translationX: 0, y: 188)
            self.homeView.myLocationButton.transform = CGAffineTransform(translationX: 0, y: 105)
        }
    }
}

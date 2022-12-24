//
//  SplashViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/28.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    // MARK: - Property
    
    private let iconImage = UIImageView().then {
        $0.image = Icon.Logo.white
        $0.alpha = 0
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAnimation()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        view.backgroundColor = Color.black100
    }
    
    override func configureLayout() {
        view.addSubview(iconImage)
        
        iconImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(35)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
    }
    
    // MARK: - Custom Method
    
    private func configureAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.2) {
            self.iconImage.image = Icon.Logo.red
            self.iconImage.alpha = 1
        } completion: { finished in
            NetworkMonitor.shared.changeUIBytNetworkConnection(vc: self) {
                let viewController = UINavigationController(rootViewController: TabBarViewController())
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .crossDissolve
                self.present(viewController, animated: false, completion: nil)
            }
        }
    }
}

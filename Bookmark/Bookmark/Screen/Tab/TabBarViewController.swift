//
//  TabBarViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
        configureTabBarViewController()
    }
    
    private func configureDelegate() {
        delegate = self
    }

    private func configureTabBarViewController() {
        UITabBar.appearance().backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        let firstTabController = HomeViewController()
        let secondTabController = BookmarkViewController()
        let thirdTabController = SettingViewController()
        
        firstTabController.tabBarItem = UITabBarItem(
            title: "홈",
            image: Icon.TabBar.unselectedMap,
            selectedImage: Icon.TabBar.map)
                
        secondTabController.tabBarItem = UITabBarItem(
            title: "책갈피",
            image: Icon.TabBar.unselectedBookmark,
            selectedImage: Icon.TabBar.bookmark)
        
        thirdTabController.tabBarItem = UITabBarItem(
            title: "설정",
            image: Icon.TabBar.unselectedSetting,
            selectedImage: Icon.TabBar.setting)
        
        self.viewControllers = [firstTabController, secondTabController, thirdTabController]
    }
}

//
//  SettingViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import SafariServices

final class SettingViewController: BaseViewController {
    
    // MARK: - Property
    
    static let sectionFooterElementKind = "section-footer-element-kind"
    
    private let settingView = SettingView()
    private let settingViewModel = SettingViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        setupDelegate()
        bindData()
    }
    
    // MARK: - Set Up Delegate
    
    override func setupDelegate() {
        settingView.setupCollectionView(self)
    }
    
    // MARK: - Bind Data
    
    private func bindData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        settingViewModel.settingList.bind { setting in
            for i in 0...2 {
                snapshot.appendSections([i])
                snapshot.appendItems(setting[i].menu, toSection: i)
            }
            self.dataSource.apply(snapshot)
        }
    }
    
    // MARK: - Custom Method
    
    private func presentSafariView(_ url: URL?) {
        guard let url = url else { return }
        let viewController = SFSafariViewController(url: url)
        transition(viewController, .present)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SettingCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            cell.setupData(data: itemIdentifier)
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <SettingSupplementaryView>(elementKind: SettingViewController.sectionFooterElementKind) {
            (supplementaryView, string, indexPath) in
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: settingView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.settingView.collectionView.dequeueConfiguredReusableSupplementary(
                using: footerRegistration, for: index)
        }
    }
}

// MARK: - CollectionView Delegate

extension SettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(item: 0, section: 0):
            self.presentSafariView(EndPoint.ask.makeURL())
            
        case IndexPath(item: 1, section: 0):
            if let appstoreUrl = URL(string: APIKey.myAppId) {
                var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
                urlComp?.queryItems = [
                    URLQueryItem(
                        name: "action",
                        value: "write-review")
                ]
                guard let reviewUrl = urlComp?.url else { return }
                UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
            }
            
        case IndexPath(item: 0, section: 1):
            showAlert(title: "준비 중입니다 :)",
                      message: nil,
                      actions: [],
                      cancelTitle: "확인",
                      preferredStyle: .alert)
            
        case IndexPath(item: 1, section: 1):
            showAlert(title: "준비 중입니다 :)",
                      message: nil,
                      actions: [],
                      cancelTitle: "확인",
                      preferredStyle: .alert)
            
        case IndexPath(item: 0, section: 2):
            self.presentSafariView(EndPoint.notion.makeURL())
            
        default:
            showAlert(title: "최신 버전입니다 :)",
                      message: nil,
                      actions: [],
                      cancelTitle: "확인",
                      preferredStyle: .alert)
        }
    }
}

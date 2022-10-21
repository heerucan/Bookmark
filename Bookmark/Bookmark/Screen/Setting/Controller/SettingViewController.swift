//
//  SettingViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import SafariServices
import StoreKit
import nanopb

final class SettingViewController: BaseViewController {
    
    // MARK: - Property
    
    static let sectionFooterElementKind = "section-footer-element-kind"
    
    private let settingView = SettingView()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        settingView.setupCollectionView(self)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        super.configureLayout()
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
                
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems(Setting.notice.menu, toSection: 0)
        snapshot.appendItems(Setting.fileManage.menu, toSection: 1)
        snapshot.appendItems(Setting.aboutBookmark.menu, toSection: 2)
        dataSource.apply(snapshot)
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
            showAlert(title: "다음 업데이트를 기다려주세요 :)",
                      message: nil,
                      actions: [],
                      cancelTitle: "확인",
                      preferredStyle: .alert)
            
        case IndexPath(item: 1, section: 1):
            showAlert(title: "다음 업데이트를 기다려주세요 :)",
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

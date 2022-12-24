//
//  SettingViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import SafariServices
import RxCocoa
import RxSwift

final class SettingViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    static let sectionFooterElementKind = "section-footer-element-kind"
    
    private let settingView = SettingView()
    private let settingViewModel = SettingViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Setting, String>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
    }
    
    // MARK: - BindViewModel
    
    private func bindViewModel() {
        settingViewModel.settingList
            .withUnretained(self)
            .subscribe { (vc, _) in
                var snapshot = NSDiffableDataSourceSnapshot<Setting, String>()
                Setting.allCases.forEach {
                    snapshot.appendSections([$0])
                    snapshot.appendItems($0.menu, toSection: $0)
                }
                vc.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
                
        settingView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { (vc, item) in
                switch item {
                case IndexPath(item: 0, section: Setting.help.rawValue):
                    vc.presentSafariView(EndPoint.ask.makeURL())
                    
                case IndexPath(item: 1, section: Setting.help.rawValue):
                    vc.presentReviewView()
                    
                case IndexPath(item: 0, section: Setting.about.rawValue):
                    vc.presentSafariView(EndPoint.notion.makeURL())
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func presentSafariView(_ url: URL?) {
        guard let url = url else { return }
        let viewController = SFSafariViewController(url: url)
        transition(viewController, .present)
    }
    
    private func presentReviewView() {
        if let appstoreUrl = URL(string: APIKey.myAppId) {
            var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
            urlComp?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
            guard let reviewUrl = urlComp?.url else { return }
            UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - DiffableDataSource {

extension SettingViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SettingCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            cell.setupData(data: itemIdentifier)
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <SettingSupplementaryView>(elementKind: SettingViewController.sectionFooterElementKind) {
            (supplementaryView, string, indexPath) in
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: settingView.collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
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

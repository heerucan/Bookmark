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
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindData()
    }
    
    // MARK: - Bind Data
    
    private func bindData() {
        settingViewModel.settingList
            .asDriver()
            .drive { [weak self] value in
                guard let self = self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
                for i in 0...2 {
                    snapshot.appendSections([i])
                    snapshot.appendItems(value[i].menu, toSection: i)
                }
                self.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
                
        settingView.collectionView.rx.itemSelected
            .asDriver()
            .drive { [weak self] item in
                guard let self = self else { return }
                switch item {
                case IndexPath(item: 0, section: 0):
                    self.presentSafariView(EndPoint.ask.makeURL())
                    
                case IndexPath(item: 1, section: 0):
                    self.presentReviewView()
                    
                case IndexPath(item: 0, section: 1):
                    self.showAlert(title: "준비 중입니다 :)",
                                 cancelTitle: "확인",
                                 preferredStyle: .alert)
                    
                case IndexPath(item: 1, section: 1):
                    self.showAlert(title: "준비 중입니다 :)",
                                 cancelTitle: "확인",
                                 preferredStyle: .alert)
                    
                case IndexPath(item: 0, section: 2):
                    self.presentSafariView(EndPoint.notion.makeURL())
                    
                default:
                    self.showAlert(title: "최신 버전입니다 :)",
                                 cancelTitle: "확인",
                                 preferredStyle: .alert)
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

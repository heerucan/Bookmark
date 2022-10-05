//
//  SettingViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import SafariServices
import StoreKit

final class SettingViewController: BaseViewController {
    
    // MARK: - Property
    
    let settingView = SettingView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        super.configureLayout()
        settingView.configureDelegate(self, self)
    }
    
    // MARK: - Custom Method
    
    private func presentSafariView(_ url: URL?) {
        guard let url = url else { return }
        let viewController = SFSafariViewController(url: url)
        transition(viewController, .present)
    }
}

// MARK: - UITableView Protocol

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Color.gray500
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.allCases[section].numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        let data = Setting.allCases[indexPath.section].menu[indexPath.row]
        cell.setupData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

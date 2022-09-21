//
//  DetailViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import SafariServices

final class DetailViewController: BaseViewController, SafariViewDelegate {
    
    // MARK: - Property
    
    var detailStoreInfo: BookStoreInfo? {
        willSet {
            self.detailStoreInfo = newValue
        }
    }
            
    let navigationBar = BookmarkNavigationBar()
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.allowsSelection = false
        $0.register(DetailTableViewCell.self,
                    forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
    private lazy var backView = UIView().then {
        $0.addSubviews([writeButton, bookmarkButton])
        $0.makeShadow(radius: 14, offset: CGSize(width: 0, height: -2), opacity: 0.1)
        $0.backgroundColor = .white
    }
    
    private let writeButton = BookmarkButton(.bookmark).then {
        $0.isDisabled = false
        $0.addTarget(self, action: #selector(touchupWriteButton), for: .touchUpInside)
    }
    
    private let bookmarkButton = UIButton().then {
        $0.setImage(Icon.Button.bookmark, for: .selected)
        $0.setImage(Icon.Button.unselectedBookmark, for: .normal)
        $0.addTarget(self, action: #selector(touchupBookmarkButton(_:)), for: .touchUpInside)
    }
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        guard let detailStoreInfo = detailStoreInfo else { return }
        navigationBar.titleLabel.text = detailStoreInfo.name
    }
    
    override func configureLayout() {
        view.addSubviews([navigationBar, tableView, backView])
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        backView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(97)
        }
        
        writeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(49)
            make.trailing.equalTo(bookmarkButton.snp.leading).offset(-12)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(49)
        }
    }
    
    override func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Custom Method
    
    private func setupAction() {
        navigationBar.backButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
        navigationBar.shareButton.addTarget(self, action: #selector(touchupShareButton), for: .touchUpInside)
    }
    
    func presentSafariView(_ safariView: SFSafariViewController) {
        transition(safariView, .present)
    }

    // MARK: - @objc
    
    @objc func touchupWriteButton() {
        let sentence = UIAlertAction(title: "공감 가는 글 한 줄", style: .default) { _ in
            let viewController = WriteViewController()
            self.transition(viewController, .push) { _ in
                viewController.viewType = .sentence
            }
        }
        let book = UIAlertAction(title: "사고 싶은 책 한 권", style: .default) { _ in
            let viewController = WriteViewController()
            self.transition(viewController, .push) { _ in
                viewController.viewType = .book
            }
        }
        showAlert(title: "어떤 책갈피를 기록하실 건가요?", message: nil,
                  actions: [sentence, book])
    }
    
    @objc func touchupBookmarkButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.setImage(Icon.Button.bookmark, for: .selected)
        } else {
            sender.setImage(Icon.Button.unselectedBookmark, for: .normal)
        }
    }
    
    @objc func touchupBackButton() {
        transition(self, .pop)
    }
    
    @objc func touchupShareButton() {
        guard let detailStoreInfo = detailStoreInfo else { return }
        showActivity(activityItems: ["🔖",
                                     detailStoreInfo.name,
                                     detailStoreInfo.address,
                                     detailStoreInfo.phone,
                                     detailStoreInfo.homeURL,
                                     detailStoreInfo.sns])
    }
}

// MARK: - TableView Protocol

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell
        else { return UITableViewCell() }
        cell.setupMapView(data: detailStoreInfo)
        cell.setupData(data: detailStoreInfo)
        cell.safariViewDelegate = self
        return cell
    }
}

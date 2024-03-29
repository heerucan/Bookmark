//
//  DetailViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import MapKit
import CoreLocation

import RealmSwift
import SafariServices

final class DetailViewController: BaseViewController, SafariViewDelegate {
    
    // MARK: - Realm
    
    let repository = BookmarkRepository.shared
    
    var tasks: Results<Store>!
        
    // MARK: - Property
    
    var detailStoreInfo: BookStoreInfo? {
        willSet {
            self.detailStoreInfo = newValue
        }
    }
            
    let navigationBar = BookmarkNavigationBar(type: .detail)
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.register(DetailTableViewCell.self,
                    forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
    private lazy var backView = UIView().then {
//        $0.addSubviews([writeButton, bookmarkButton])
        $0.addSubviews([writeButton])
        $0.makeShadow(radius: 14, offset: CGSize(width: 0, height: -2), opacity: 0.1)
        $0.backgroundColor = .white
    }
    
    private let writeButton = BookmarkButton(.bookmark).then {
        $0.isDisabled = false
        $0.addTarget(self, action: #selector(touchupWriteButton), for: .touchUpInside)
    }
    
//    let bookmarkButton = UIButton().then {
//        $0.setImage(Icon.Button.bookmark, for: .selected)
//        $0.setImage(Icon.Button.unselectedBookmark, for: .normal)
//        $0.addTarget(self, action: #selector(touchupBookmarkButton(_:)), for: .touchUpInside)
//    }
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRealm()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func configureLayout() {
        view.addSubviews([navigationBar,
                          tableView,
                          backView])
        
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
            make.height.equalTo(95)
        }
        
//        bookmarkButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(7)
//            make.leading.equalToSuperview().inset(16)
//            make.height.equalTo(54)
//        }
        
        writeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
//            make.leading.equalTo(bookmarkButton.snp.trailing).offset(7)
        }
    }
    
    override func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Custom Method
    
    private func setupRealm() {
        self.tasks = repository.fetchBookmark()

    }
    
    private func setupAction() {
        navigationBar.leftButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
        navigationBar.rightButton.addTarget(self, action: #selector(touchupShareButton), for: .touchUpInside)
    }
    
    func presentSafariView(_ safariView: SFSafariViewController) {
        transition(safariView, .present)
    }

    // MARK: - @objc
    
    @objc func touchupWriteButton() {
        let sentence = UIAlertAction(title: "addWriting".localized, style: .default) { _ in
            let viewController = WriteViewController()
            self.transition(viewController, .push) { _ in
                guard let detailStoreInfo = self.detailStoreInfo else { return }
                viewController.writeView.writeViewState = .sentence
                viewController.writeView.bookStore = detailStoreInfo.name
                viewController.fromWhatView = .detail
            }
        }
        let book = UIAlertAction(title: "addBook".localized, style: .default) { _ in
            let viewController = WriteViewController()
            self.transition(viewController, .push) { _ in
                guard let detailStoreInfo = self.detailStoreInfo else { return }
                viewController.writeView.writeViewState = .book
                viewController.writeView.bookStore = detailStoreInfo.name
                viewController.fromWhatView = .detail
//                viewController.bookmark = self.bookmarkButton.isSelected
            }
        }
        showAlert(title: "addActionSheetTitle".localized,
                  actions: [sentence, book])
    }
    
    @objc func touchupBookmarkButton(_ sender: UIButton) {
        guard let detailStoreInfo = detailStoreInfo else { return }
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.setImage(Icon.Button.bookmark, for: .selected)
            repository.updateBookmark(item: ["name": detailStoreInfo.name,
                                             "bookmark": true])
        } else if !sender.isSelected {
            sender.setImage(Icon.Button.unselectedBookmark, for: .normal)
            repository.updateBookmark(item: ["name": detailStoreInfo.name,
                                             "bookmark": false])
        }
    }
    
    @objc func touchupBackButton() {
        transition(self, .pop)
    }
    
    @objc func touchupShareButton() {
        guard let detailStoreInfo = detailStoreInfo else { return }
        showActivity(activityItems: ["🔖 책갈피",
                                     detailStoreInfo.name,
                                     detailStoreInfo.address,
                                     detailStoreInfo.phone,
                                     detailStoreInfo.homeURL,
                                     detailStoreInfo.sns])
    }
    
    @objc func touchupMapAppButton() {
        guard let detailStoreInfo = detailStoreInfo else { return }
        let apple = UIAlertAction(title: "AppleMap".localized, style: .default) { _ in
            let coordinate = CLLocationCoordinate2DMake(Double(detailStoreInfo.latitude)!, Double(detailStoreInfo.longtitude)!)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = detailStoreInfo.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
        let naver = UIAlertAction(title: "NaverMap".localized, style: .default) { _ in
            guard let naver = EndPoint.naver.makeURL(detailStoreInfo.name) else { return }
            if UIApplication.shared.canOpenURL(naver) {
                UIApplication.shared.open(naver)
            } else {
                self.showAlert(title: "noNaver".localized)
            }
        }
        let kakao = UIAlertAction(title: "KakaoMap".localized, style: .default) { _ in
            guard let kakao = EndPoint.kakao.makeURL("\(detailStoreInfo.latitude),\(detailStoreInfo.longtitude)") else { return }
            if UIApplication.shared.canOpenURL(URL(string: "kakaomap://open")!) {
                UIApplication.shared.open(kakao)
            } else {
                self.showAlert(title: "noKakao".localized)
            }
        }
        let google = UIAlertAction(title: "GoogleMap".localized, style: .default) { _ in
            guard let google = EndPoint.google.makeURL("\(detailStoreInfo.latitude),\(detailStoreInfo.longtitude)") else { return }
            if UIApplication.shared.canOpenURL((URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.open(google)
            } else {
                self.showAlert(title: "noGoogle".localized)
            }
        }
        showAlert(title: "mapActionSheetTitle".localized,
                  actions: [apple, naver, kakao, google],
                  preferredStyle: .actionSheet)
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
        cell.mapAppButton.addTarget(self, action: #selector(touchupMapAppButton), for: .touchUpInside)
        return cell
    }
}

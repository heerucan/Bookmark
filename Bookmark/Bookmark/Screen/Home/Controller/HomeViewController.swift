//
//  HomeViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import FirebaseAnalytics
import RealmSwift
import CoreLocation
import NMapsMap

final class HomeViewController: BaseViewController {
    
    // MARK: - Realm
    
    let repository = BookmarkRepository.shared
    
    var tasks: Results<Store>! {
        didSet {
//            print("📪bookmarkButton 변화 발생", tasks as Any)
        }
    }
    
    // MARK: - Property
    
    private let homeView = HomeView()
    private let tagData = TagData()
    
    private var isNewSelected: Bool = false
    private var isOldSelected: Bool = false
    private var isBookmarkSelected: Bool = false
    
    private let geocoder = CLGeocoder()
    
    private let locationManager = CLLocationManager().then {
        $0.distanceFilter = 10000
    }
    
    private lazy var myLatitude = locationManager.location?.coordinate.latitude
    private lazy var myLongtitude = locationManager.location?.coordinate.longitude
    
    private var markers: [NMFMarker] = []
    
    private var bookmarkArray: [String] = []

    private var newStoreList: [BookStoreInfo] = []
    private var oldStoreList: [BookStoreInfo] = []
    private var bookStoreList: [BookStoreInfo] = []
    
    private var selectedStoreInfo: BookStoreInfo? {
        willSet {
            self.selectedStoreInfo = newValue
        }
    }
    
    private var locationUpdateCount: Int = 0 {
        didSet {
            if locationUpdateCount == 1 {
            }
        }
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        requestAPI()
        setupFirebaseAnalytics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        setupRealm()
    }
    
    // MARK: - Delegate
    
    override func setupDelegate() {
        locationManager.delegate = self
        homeView.setupMapDelegate(self, self)
        homeView.setupCollectionViewDelegate(self, self)
    }
    
    // MARK: - Network
    
    private func requestAPI() {
        StoreAPIManager.shared.fetchBookStore(endIndex: 1000) { [weak self] (data, status, error) in
            guard let self = self,
                  let data = data else { return }
            self.bookStoreList = data.total.info
            self.oldStoreList = self.bookStoreList.filter { $0.typeNo == Matrix.old }
            self.newStoreList = self.bookStoreList.filter { $0.typeNo == Matrix.new }
            DispatchQueue.main.async {
                self.updateMarker(filter: .all)
            }
        }
    }
    
    // MARK: - Custom Method
    
    private func setupAction() {
        [homeView.searchButton,
         homeView.locationButton,
         homeView.storeButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
        }
    }
    
    private func setupRealm() {
        self.tasks = repository.fetchBookmark()
    }
    
    // MARK: - Customize Map
    
    private func updateCurrentLocation() {
        guard let lat = locationManager.location?.coordinate.latitude,
              let long = locationManager.location?.coordinate.longitude else { return }
        locationManager.stopUpdatingLocation()
        let coordinate = NMGLatLng(lat: lat, lng: long)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate, zoomTo: 14)
        cameraUpdate.animation = .linear
        homeView.mapView.moveCamera(cameraUpdate)
    }
    
    private func setupMarker(storeList: [BookStoreInfo], tag: Int) {
        markers.removeAll()
        for bookStore in storeList {
            guard let lat = Double(bookStore.latitude),
                  let lng = Double(bookStore.longtitude) else { return }
            let coordinate = NMGLatLng(lat: lat, lng: lng)
            let marker = NMFMarker()
            marker.position = coordinate
            marker.isHideCollidedMarkers = true
            marker.isHideCollidedSymbols = true
            marker.tag = UInt(tag)
            marker.width = Matrix.markerWidth
            marker.height = Matrix.markerHeight
            marker.iconPerspectiveEnabled = true
            marker.iconImage = NMFOverlayImage(name: Icon.marker)
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self,
                      let lat = self.myLatitude,
                      let long = self.myLongtitude else { return false }
                let myCoordinate = NMGLatLng(lat: lat, lng: long)
                self.markers.forEach {
                    $0.iconImage = NMFOverlayImage(name: Icon.marker)
                }
                marker.iconImage = NMFOverlayImage(name: Icon.selectedMarker)
                self.homeView.setupData(data: bookStore, distance: myCoordinate.distance(to: coordinate))
                self.transformView(.storeButtonShow)
                self.selectedStoreInfo = bookStore
                return true
            }
            marker.mapView = homeView.mapView
            markers.append(marker)
        }
    }
    
    private func updateMarker(filter: BookFilter) {
        switch filter {
        case .new:
            if isNewSelected {
                isOldSelected = false
                markers.filter { $0.tag != 0 }.forEach { $0.mapView = nil }
                setupMarker(storeList: self.newStoreList, tag: 0)
            } else {
                markers.filter { $0.tag == 0 }.forEach { $0.mapView = nil }
                setupMarker(storeList: self.bookStoreList, tag: 2)
            }
            
        case .old:
            if isOldSelected {
                isNewSelected = false
                markers.filter { $0.tag != 1 }.forEach { $0.mapView = nil }
                setupMarker(storeList: self.oldStoreList, tag: 1)
            } else {
                markers.filter { $0.tag == 1 }.forEach { $0.mapView = nil }
                setupMarker(storeList: self.bookStoreList, tag: 2)
            }
            
        case .all:
            isOldSelected = false
            isNewSelected = false
            self.homeView.mapView.zoomLevel = 13
            setupMarker(storeList: self.bookStoreList, tag: 2)
            
//        case .bookmark:
//            if isBookmarkSelected {
//                markers.filter { $0.tag != 3 }.forEach { $0.mapView = nil }
//                tasks.forEach { bookmarkArray.append($0.name) }
//                self.bookStoreList.forEach { store in
//                    if bookmarkArray.contains(store.name) {
//                        markers.forEach { $0.iconImage =  NMFOverlayImage(name: Icon.bookMarker) }
//                        setupMarker(storeList: self.bookStoreList.filter { $0.name == store.name }, tag: 3)
//                    }
//                }
//            } else {
//                markers.filter { $0.tag == 3 }.forEach { $0.mapView = nil }
//                setupMarker(storeList: self.bookStoreList, tag: 2)
//            }
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupButton(_ sender: UIButton) {
        switch sender {
        case homeView.searchButton:
            let viewController = SearchViewController()
            transition(viewController)
            
        case homeView.locationButton:
            locationManager.startUpdatingLocation()
            updateCurrentLocation()
            
        case homeView.storeButton:
            let viewController = DetailViewController()
            transition(viewController, .push) { _ in
                guard let selectedStoreInfo = self.selectedStoreInfo,
                      let name = self.homeView.nameLabel.text else { return }
                viewController.detailStoreInfo = selectedStoreInfo
                                
//                print("📮", self.bookmarkArray.map { $0 } )
                // 이름이 북마크된 서점 목록리스트에 속한 경우에만 true로 처리해줘야 함
//                print(self.repository.fetchBookmark())
//                viewController.bookmarkButton.isSelected = (name == selectedStoreInfo.name) ? true : false
            }
        default:
            break
        }
    }
}

// MARK: - CollectionView Protocol

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagData.getTagCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTagCollectionViewCell.identifier, for: indexPath) as? HomeTagCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setupData(index: indexPath.item)
        cell.makeShadow(radius: 2, offset: CGSize(width: 0, height: 1), opacity: 0.25)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeTagCollectionViewCell else { return }
        if cell.clickCount == 1 {
            markers.forEach { $0.mapView = nil }
            cell.clickCount = 0
        } else {
            markers.forEach { $0.mapView = nil }
            cell.clickCount += 1
        }
        
        if cell.tagLabel.text == "새책방" {
            isNewSelected.toggle()
            updateMarker(filter: .new)
        } else if cell.tagLabel.text == "헌책방" {
            isOldSelected.toggle()
            updateMarker(filter: .old)
        } else {
            updateMarker(filter: .all)
        }
        
//        if indexPath.item == 2 && cell.isSelected {
//            isBookmarkSelected.toggle()
//            updateMarker(filter: .old)
//        }
    }
}

// MARK: - Naver Map View Touch & Camera CallBack Protocol

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        transformView(.storeButtonHidden)
    }
}

// MARK: - CLLocation Manager Protocol

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            myLatitude = coordinate.latitude
            myLongtitude = coordinate.longitude
            updateCurrentLocation()
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("😡 사용자의 위치를 가져오지 못했습니다.")
        checkUserCurrentLocationAuthorization(locationManager.authorizationStatus)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserDeviceLocationServiceAuthorization()
    }
}

// MARK: - 위치 서비스 활성화 체크

extension HomeViewController {
    private func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            showLocationServiceAlert()
        }
    }
    
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("아직 결정 X")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("거부 or 아이폰 설정 유도")
            showLocationServiceAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("🤩 WHEN IN USE or ALWAYS")
            locationManager.startUpdatingLocation() // 정확도를 위해서 무한대로 호출
        default:
            print("DEFAULT")
        }
    }
    
    private func showLocationServiceAlert() {
        let setting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            }
        }
        showAlert(title: "위치 정보 이용",
                  message: Matrix.settingMessage,
                  actions: [setting],
                  preferredStyle: .alert)
    }
}

// MARK: - UIView.animate

extension HomeViewController {
    private func transformView(_ viewState: ComponentStatus) {
        switch viewState {
        case .storeButtonHidden:
            UIView.animate(withDuration: 0.2) {
                self.homeView.storeButton.transform = .identity
                self.homeView.locationButton.transform = .identity
            }
        case .storeButtonShow:
            UIView.animate(withDuration: 0.1) {
                self.homeView.storeButton.transform = CGAffineTransform(
                    translationX: 0,
                    y: -self.homeView.storeButton.frame.height)
                self.homeView.locationButton.transform = CGAffineTransform(
                    translationX: 0,
                    y: -self.homeView.locationButton.frame.height-40)
            }
        }
    }
}

// MARK: - Firebase

extension HomeViewController {
    private func setupFirebaseAnalytics() {
        Analytics.logEvent("analyticsUser", parameters: [
          "name": "이름" as NSObject,
          "full_text": "텍스트" as NSObject,
        ])
    }
}

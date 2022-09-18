//
//  HomeViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import CoreLocation
import NMapsMap

final class HomeViewController: BaseViewController {
    
    // MARK: - Property
    
    private let tagData = TagData()
    
    private let homeView = HomeView()
    
    private let locationManager = CLLocationManager()
    private lazy var myLatitude = locationManager.location?.coordinate.latitude
    private lazy var myLongtitude = locationManager.location?.coordinate.longitude
    
    private var markers: [NMFMarker] = []
    
    private var bookStoreList: [BookStoreInfo] = []
    private var selectedStoreInfo: BookStoreInfo? {
        willSet {
            self.selectedStoreInfo = newValue
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Delegate
    
    override func setupDelegate() {
        locationManager.delegate = self
        homeView.setupMapDelegate(self, self)
        homeView.setupCollectionViewDelegate(self, self)
    }
    
    // MARK: - Network
    
    private func requestAPI() {
        StoreAPIManager.shared.fetchBookStore() { (data, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.bookStoreList.append(contentsOf: data.total.info)
                self.setupMarker(Matrix.new)
                self.setupMarker(Matrix.old)
            }
        }
    }
    
    // MARK: - Custom Method
    
    private func setupAction() {
        [homeView.goToSearchViewButton,
         homeView.findButton,
         homeView.myLocationButton,
         homeView.storeButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Customize Map
    
    private func updateMyLocation() {
        guard let lat = myLatitude, let long = myLongtitude else { return }
        let coordinate = NMGLatLng(lat: lat, lng: long)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate)
        cameraUpdate.animation = .easeIn
        homeView.mapView.moveCamera(cameraUpdate)
    }
    
    private func setupMarker(_ typeNo: String? = nil) {
        guard let typeNo = typeNo else { return }
        let storeList = bookStoreList.filter { $0.typeNo == typeNo }
        for bookStore in storeList {
            guard let lat = Double(bookStore.latitude),
                  let lng = Double(bookStore.longtitude) else { return }
            let coor = NMGLatLng(lat: lat, lng: lng)
            let marker = NMFMarker()
            marker.isHideCollidedMarkers = true
            marker.position = coor
            marker.width = Matrix.markerSize
            marker.height = Matrix.markerSize
            marker.iconImage = NMFOverlayImage(name: Icon.Image.marker)
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self,
                      let lat = self.myLatitude,
                      let long = self.myLongtitude else { return false }
                let myCoordinate = NMGLatLng(lat: lat, lng: long)
                self.homeView.setupData(data: bookStore, distance: myCoordinate.distance(to: coor))
                self.transformView(.storeButtonNotHidden)
                self.selectedStoreInfo = bookStore
                return true
            }
            marker.mapView = homeView.mapView
            markers.append(marker)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupButton(_ sender: UIButton) {
        switch sender {
        case homeView.goToSearchViewButton:
            let viewController = SearchViewController()
            transition(viewController)
        case homeView.findButton:
            transformView(.findButtonHidden)
        case homeView.myLocationButton:
            updateMyLocation()
        case homeView.storeButton:
            let viewController = DetailViewController()
            transition(viewController, .push) { _ in
                viewController.detailStoreInfo = self.selectedStoreInfo
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeTagCollectionViewCell else { return }
        if cell.clickCount == 1 {
            cell.clickCount = 0
        } else {
            cell.clickCount += 1
        }
        
        // MARK: - TODO 렘 연결 후 0번째는 책갈피
        if indexPath.item == 1 && cell.isSelected {
            markers.removeAll()
            setupMarker(Matrix.new)
        } else if indexPath.item == 2 && cell.isSelected {
            markers.removeAll()
            setupMarker(Matrix.old)
        } else {
            markers.removeAll()
            setupMarker(Matrix.new)
            setupMarker(Matrix.old)
        }
    }
}

// MARK: - 지도 터치 프로토콜 & 지도 이동 콜백 프로토콜

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        transformView(.storeButtonHidden)
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        homeView.mapView.locationOverlay.location = NMGLatLng(lat: mapView.latitude, lng: mapView.longitude)
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        homeView.mapView.locationOverlay.location = NMGLatLng(lat: mapView.latitude, lng: mapView.longitude)
        transformView(.findButtonNotHidden)
    }
}

// MARK: - CLLocation Protocol

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            myLatitude = coordinate.latitude
            myLongtitude = coordinate.longitude
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
            locationManager.startUpdatingLocation()
            
        default: print("DEFAULT")
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
                self.homeView.myLocationButton.transform = .identity
            }
        case .storeButtonNotHidden:
            UIView.animate(withDuration: 0.1) {
                self.homeView.storeButton.transform = CGAffineTransform(
                    translationX: 0,
                    y: -self.homeView.storeButton.frame.height-16)
                self.homeView.myLocationButton.transform = CGAffineTransform(
                    translationX: 0,
                    y: -self.homeView.myLocationButton.frame.height-40)
            }
        case .findButtonHidden:
            UIView.animate(withDuration: 0.1) {
                self.homeView.findButton.alpha = 0
            }
        case .findButtonNotHidden:
            UIView.animate(withDuration: 0.2) {
                self.homeView.findButton.alpha = 1
            }
        }
    }
}

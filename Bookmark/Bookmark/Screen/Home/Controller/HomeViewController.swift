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
    
    private var isNewSelected: Bool = false
    private var isOldSelected: Bool = false
    
    private let tagData = TagData()
    
    private let homeView = HomeView()
    
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private lazy var myLatitude = locationManager.location?.coordinate.latitude
    private lazy var myLongtitude = locationManager.location?.coordinate.longitude
    
    private var markers: [NMFMarker] = []
    
    private var newStoreList: [BookStoreInfo] = []
    private var oldStoreList: [BookStoreInfo] = []
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
        StoreAPIManager.shared.fetchBookStore() { [weak self] (data, error) in
            guard let self = self,
                  let data = data else { return }
            self.bookStoreList = data.total.info
            self.oldStoreList = self.bookStoreList.filter { $0.typeNo == Matrix.old }
            self.newStoreList = self.bookStoreList.filter { $0.typeNo == Matrix.new }
            let bounds = self.makeBoundsToMap(nmgLatLng: NMGLatLng(lat: self.myLatitude!, lng: self.myLongtitude!), value: 100)
            DispatchQueue.main.async {
                self.homeView.mapView.zoomLevel = 9
                self.setupMarker(bounds: bounds, storeList: self.bookStoreList)
            }
        }
    }
    
    // MARK: - Custom Method
    
    private func setupAction() {
        [homeView.goToSearchViewButton,
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
    
    private func makeBoundsToMap(nmgLatLng: NMGLatLng, value: Double) -> NMGLatLngBounds {
        let southWest = NMGLatLng(
            lat: nmgLatLng.lat - nmgLatLng.lat/value,
            lng: nmgLatLng.lng - nmgLatLng.lng/value)
        let northEast = NMGLatLng(
            lat: nmgLatLng.lat + nmgLatLng.lat/value,
            lng: nmgLatLng.lng + nmgLatLng.lng/value)
        lazy var bounds = NMGLatLngBounds(southWest: southWest, northEast: northEast)
        return bounds
    }
    
    // 마커 세팅
    private func setupMarker(bounds: NMGLatLngBounds? = nil, storeList: [BookStoreInfo]) {
        markers.removeAll()
        markers.forEach { $0.mapView = nil }
        guard let bounds = bounds else { return }
        for bookStore in storeList {
            guard let lat = Double(bookStore.latitude),
                  let lng = Double(bookStore.longtitude) else { return }
            let coordinate = NMGLatLng(lat: lat, lng: lng)
            let marker = NMFMarker()
            // 마커들이 너가 만들어준 직사각형 바운드 영역에 속하는가 물어보는 것 ->
            // 그래서 들어간다면, 포함하면 yes -> 마커를 보여주는 것임....
            if bounds.hasPoint(coordinate) {
                marker.position = coordinate
            }
            marker.isHideCollidedMarkers = true
            marker.width = Matrix.markerSize
            marker.height = Matrix.markerSize
            marker.iconImage = NMFOverlayImage(name: Icon.Image.marker)
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self,
                      let lat = self.myLatitude,
                      let long = self.myLongtitude else { return false }
                let myCoordinate = NMGLatLng(lat: lat, lng: long)
                self.homeView.setupData(data: bookStore, distance: myCoordinate.distance(to: coordinate))
                self.transformView(.storeButtonShow)
                self.selectedStoreInfo = bookStore
                return true
            }
            marker.mapView = homeView.mapView
            markers.append(marker)
        }
    }
    
    // 마커 필터링

    enum BookFilter {
        case new
        case old
        case all
        
        var typeNo: String? {
            switch self {
            case .new:
                return Matrix.new
            case .old:
                return Matrix.old
            case .all:
                return nil
            }
        }
    }
    
    private func updateMarker(filter: BookFilter) {
        
//        markers.forEach { $0.mapView = nil } // 기존에 있던 전체 마커 지우기
        
        let bounds = makeBoundsToMap(nmgLatLng: homeView.mapView.locationOverlay.location, value: 4000)
        
        switch filter {
        case .new:
            if isNewSelected {
                print("1")
                let bounds = makeBoundsToMap(nmgLatLng: homeView.mapView.locationOverlay.location, value: 4000)
                markers.forEach { $0.mapView = nil } // new 마커 삭제
                setupMarker(bounds: bounds, storeList: newStoreList)
                
            } else {
                print("2")
                
                
                
                // 원래 새책방 체크해제 후에 그린색으로 헌책방이 보여야 하는데 안보이는 이유는 여기서 마커를 다 없애서
                // 보여줄 마커가 없음 -> 그래서 헌책방을 선택해도 헌책방이 3번에서 보이지 않는 것임
                // 그리고 다시 헌책방을 해제 후에 노란색 마커로 newStoreList가 보이는 건 setupMarker로 헌책방을 해제하고 새책방리스트를 orange 색으로 핀찍어줘서임
                
                // 그러면 헌책방이 먼저 보여주려면, markers를 nil해야 하는데 그러면 새책방을 어떻게 없애주지?? 어렵네;;
                
                
                
                markers.forEach { $0.mapView = nil }
                setupMarker(bounds: bounds, storeList: oldStoreList)
                
            }
            
        case .old:
            if isOldSelected {
                print("3")
                markers.forEach { $0.mapView = nil }
                setupMarker(bounds: bounds, storeList: oldStoreList)
            } else {
                print("4")
                markers.forEach { $0.mapView = nil } // old 마커 삭제
                setupMarker(bounds: bounds, storeList: newStoreList)
            }
            
        case .all:
            print("지도움직일때")
//            markers.forEach { $0.mapView = nil }
//            filterMarker(bounds: bounds, storeList: newStoreList + oldStoreList)
//            setupMarker(bounds: bounds, storeList: newStoreList + oldStoreList)
        }
        print("📦", markers.count, filter, "//new-", isNewSelected, "//old-", isOldSelected)
        
    }
    
    // MARK: - @objc
    
    @objc func touchupButton(_ sender: UIButton) {
        switch sender {
        case homeView.goToSearchViewButton:
            let viewController = SearchViewController()
            transition(viewController)

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
    
    // 셀 태그 버튼 선택 시 호출
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeTagCollectionViewCell else { return }
        if cell.clickCount == 1 {
            cell.clickCount = 0
        } else {
            cell.clickCount += 1
        }
        
        // MARK: - TODO 여기 고치거나 지워야 함
        if indexPath.item == 1 && cell.isSelected {
//            isNewSelected.toggle()
//            updateMarker(filter: .new)
            
        } else if indexPath.item == 2 && cell.isSelected {
//            isOldSelected.toggle()
//            updateMarker(filter: .old)
            
        } else {
            
            
        }
    }
}

// MARK: - 지도 터치 프로토콜 & 지도 이동 콜백 프로토콜

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        transformView(.storeButtonHidden)
    }
    
    // 카메라 멈추는 동안에 호출
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        homeView.mapView.locationOverlay.location = NMGLatLng(lat: mapView.latitude, lng: mapView.longitude)
    }
    
    
    
    
    // 카메라 멈췄을 때 호출
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        homeView.mapView.locationOverlay.location = NMGLatLng(lat: mapView.latitude, lng: mapView.longitude)
        print("📒지도 멈춤")
//        let bounds = makeBoundsToMap(nmgLatLng: homeView.mapView.locationOverlay.location, value: 4000)
//        markers.forEach { $0.mapView = nil } // new 마커 삭제
//        setupMarker(bounds: bounds, storeList: bookStoreList)
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
        case .storeButtonShow:
            UIView.animate(withDuration: 0.1) {
                self.homeView.storeButton.transform = CGAffineTransform(
                    translationX: 0,
                    y: -self.homeView.storeButton.frame.height-16)
                self.homeView.myLocationButton.transform = CGAffineTransform(
                    translationX: 0,
                    y: -self.homeView.myLocationButton.frame.height-40)
            }
        }
    }
}

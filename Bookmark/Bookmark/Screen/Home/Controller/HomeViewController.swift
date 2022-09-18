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
    
    private let homeView = HomeView()
    
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private lazy var myLatitude = locationManager.location?.coordinate.latitude
    private lazy var myLongtitude = locationManager.location?.coordinate.longitude
    
    var markers: [NMFMarker] = []
    
    // 배열을 만들어서 필터링된 행정구역의 서점들을 추가하기.
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
    
    // MARK: - Configure UI & Layout & Delegate
    
    override func setupDelegate() {
        locationManager.delegate = self
        homeView.setupDelegate(touchDelegate: self, cameraDelegate: self)
    }
    
    // MARK: - RequestAPI
    
    private func requestAPI() {
        StoreAPIManager.shared.fetchBookStore() { (data, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.bookStoreList.append(contentsOf: data.total.info)
                self.setupMarker()
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
    
    private func setupMarker() {
        for bookStore in self.bookStoreList {
            guard let latitude = Double(bookStore.latitude),
                  let longtitude = Double(bookStore.longtitude) else { return }
            let coordinate = NMGLatLng(lat: latitude, lng: longtitude)
            let marker = NMFMarker()
            marker.position = coordinate
            marker.width = Matrix.markerSize
            marker.height = Matrix.markerSize
            marker.iconImage = NMFOverlayImage(name: Icon.Image.marker)
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self,
                      let lat = self.myLatitude,
                      let long = self.myLongtitude else { return false }
                let myCoordinate = NMGLatLng(lat: lat, lng: long)
                self.homeView.setupData(data: bookStore, distance: myCoordinate.distance(to: coordinate))
                self.transformView(.storeButtonNotHidden)
                self.selectedStoreInfo = bookStore
                return true
            }
            marker.mapView = homeView.mapView
            markers.append(marker)
        }
    }
    
    private func updateMyLocation() {
        guard let lat = myLatitude, let long = myLongtitude else { return }
        let coordinate = NMGLatLng(lat: lat, lng: long)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate)
        cameraUpdate.animation = .easeIn
        homeView.mapView.moveCamera(cameraUpdate)
    }
    
    @discardableResult
    private func findAddress(_ lat: CLLocationDegrees, _ long: CLLocationDegrees) -> String {
        let locale = Locale(identifier: "Ko-kr")
        let location = CLLocation(latitude: lat, longitude: long)
        var address = ""
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { (placemarks, nil) in
            guard let district = placemarks?.last?.subLocality else { return }
//            return district
            address = district
            print(address, placemarks?.last)
        }
        return address
    }
    
    // MARK: - @objc
    
    @objc func touchupButton(_ sender: UIButton) {
        switch sender {
        case homeView.goToSearchViewButton:
            let viewController = SearchViewController()
            navigationController?.pushViewController(viewController, animated: true)
            
        case homeView.findButton:
            transformView(.findButtonHidden)
            
        case homeView.myLocationButton:
            updateMyLocation()
            
        case homeView.storeButton:
            let viewController = DetailViewController()
            viewController.detailStoreInfo = selectedStoreInfo
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - 지도 터치와 지도 이동에 대한 콜백 프로토콜

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        transformView(.storeButtonHidden)
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//        UIView.animate(withDuration: 0.2) {
//            self.markers.forEach { $0.alpha = 0 }
//        }
        homeView.mapView.locationOverlay.location = NMGLatLng(lat: mapView.latitude, lng: mapView.longitude)
    }
    
    // 움직임이 끝나면 호출
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        print("🥝 지도 이동했다!")
        homeView.mapView.locationOverlay.location = NMGLatLng(lat: mapView.latitude, lng: mapView.longitude)
//        UIView.animate(withDuration: 0.2) {
//            self.markers.forEach { $0.alpha = 1 }
//        }
        transformView(.findButtonNotHidden)
//        findAddress(markers[0].position.lat, markers[0].position.lng)
    }
}

// MARK: - CLLocation Protocol

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("😡 사용자의 위치를 가져오지 못했습니다.")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
}

// MARK: - UIView.animate & 위치 서비스 활성화 체크

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
    
    // 환경설정 -> 개인 정보 보호 -> 위치 서비스 체크
    private func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        
        // iOS 위치 서비스 활성화 여부 체크
        // 해당 메소드가 위치 서비스 여부를 체크해준다.
        if CLLocationManager.locationServicesEnabled() {
            // 위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            showRequestLocationServiceAlert()
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    /*
     사용자의 위치 서비스가 활성화된 것을 확인 후, 그 다음 위치 권한 상태 확인
     사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인
     */
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("🤩 WHEN IN USE or ALWAYS")
            locationManager.startUpdatingLocation()
            updateMyLocation()
            
        default: print("DEFAULT")
        }
    }
    
    private func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치정보 이용",
            message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

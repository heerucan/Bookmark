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
    
    private var bookStoreList: [BookStoreInfo] = []
        
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
    
    // MARK: - Custom Map
    
    private func setupMarker() {
        // MARK: - 여기서 사용자가 지도를 움직일 때마다 지도의 lat,long 값을 반환해주면 그걸로 findAddress를 통해서 행정구를 가져오고
        // 그래서 해당 행정구가 어디인지 알아서 filtering을 해주는 것임 1차적으로
        // 그래서 나는 현 지도 검색을 하는 경우에는 Overlay를 다른색으로 제공해주는 것도 괜찮을 것 같음
        let cameraPosition = homeView.mapView.cameraPosition
        findAddress(cameraPosition.target.lat, cameraPosition.target.lng)

        for bookStore in self.bookStoreList {
            guard let latitude = Double(bookStore.latitude),
                  let longtitude = Double(bookStore.longtitude) else { return }
            let coordinate = NMGLatLng(lat: latitude, lng: longtitude)
            print("🎒", bookStore.district)
            findAddress(latitude, longtitude)
            let marker = NMFMarker()
            marker.position = coordinate
            marker.width = Matrix.markerSize
            marker.height = Matrix.markerSize
            marker.iconImage = NMFOverlayImage(name: Icon.Image.marker)
            marker.mapView = homeView.mapView
            let markerHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self else { return false }
                self.homeView.setupData(data: bookStore, kilometer: self.updateMyLocation().distance(to: coordinate))
                UIView.animate(withDuration: 0.1) {
                    self.homeView.storeButton.transform = CGAffineTransform(translationX: 0, y: -self.homeView.storeButton.frame.height-16)
                    self.homeView.myLocationButton.transform = CGAffineTransform(translationX: 0, y: -self.homeView.myLocationButton.frame.height-40)
                }
                return true
            }
            marker.touchHandler = markerHandler
        }
    }
    
    @discardableResult
    private func updateMyLocation() -> NMGLatLng {
        if let lat = myLatitude, let long = myLongtitude {
            let coordinate = NMGLatLng(lat: lat, lng: long)
            let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate)
            cameraUpdate.animation = .easeIn
            homeView.mapView.moveCamera(cameraUpdate)
            return coordinate
        } else {
            return NMGLatLng()
        }
    }
    
    private func findAddress(_ lat: CLLocationDegrees, _ long: CLLocationDegrees) {
        let locale = Locale(identifier: "Ko-kr")
        let location = CLLocation(latitude: lat, longitude: long)
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { (placemarks, nil) in
            if let district = placemarks?.last?.subLocality {
                print(district)
            }
        }
    }
    
    // MARK: - @objc

    @objc func touchupButton(_ sender: UIButton) {
        switch sender {
        case homeView.goToSearchViewButton:
            let viewController = SearchViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case homeView.findButton:
            setupMarker()
            UIView.animate(withDuration: 0.1) {
                self.homeView.findButton.alpha = 0
            }
        case homeView.myLocationButton:
            updateMyLocation()
        case homeView.storeButton:
            let viewController = DetailViewController()
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - 지도 터치에 대한 콜백 프로토콜

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        UIView.animate(withDuration: 0.2) {
            self.homeView.storeButton.transform = .identity
            self.homeView.myLocationButton.transform = .identity
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        UIView.animate(withDuration: 0.2) {
            self.homeView.findButton.alpha = 1
        }
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

// MARK: - 위치 서비스 활성화 체크

extension HomeViewController {
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
     (단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
     */
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            
            /*
             1. kCLLocationAccuracyBest : 각각의 기기에 맞는 위치 정확도를 알아서 해줌
             2. 앱을 사용하는 동안에 위치 권한을 요청
             -> 단, plist에 WhenInUse가 등록되어야 해당 request~ 메소드를 사용할 수 있다.
             */
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("🤩 WHEN IN USE or ALWAYS")
            // 사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메소드가 실행된다.
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

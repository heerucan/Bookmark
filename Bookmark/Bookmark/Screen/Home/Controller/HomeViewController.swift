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
    
    private let testLatitude =  37.56677780536712
    private let testLongtitude = 126.92908615722659
    
    private let homeView = HomeView()
    
    private let locationManager = CLLocationManager()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Configure UI & Layout
    
    override func setupDelegate() {
        locationManager.delegate = self
        homeView.setupDelegate(delegate: self)
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
    
    private func setupMarker() {
        let nmgLatLng = NMGLatLng(lat: testLatitude, lng: testLongtitude)
        let marker = NMFMarker()
        marker.position = nmgLatLng
        marker.iconImage = NMFOverlayImage(name: Icon.Image.marker)
        marker.mapView = homeView.mapView
    }
    
    private func updateCurrentLocation() {
        guard let latitude = locationManager.location?.coordinate.latitude,
              let longtitude = locationManager.location?.coordinate.longitude else { return }
        
        let nmgLatLng = NMGLatLng(lat: latitude, lng: longtitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: nmgLatLng)
        cameraUpdate.animation = .easeIn
        homeView.mapView.moveCamera(cameraUpdate)
    }
    
//    private func 
    
    // MARK: - @objc

    @objc func touchupButton(_ sender: UIButton) {
        switch sender {
        case homeView.goToSearchViewButton:
            let viewController = SearchViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case homeView.findButton:
            setupMarker()
        case homeView.myLocationButton:
            updateCurrentLocation()
        case homeView.storeButton:
            let viewController = DetailViewController()
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - 지도 터치에 대한 콜백 프로토콜.

extension HomeViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        UIView.animate(withDuration: 0.2) {
            self.homeView.storeButton.transform = CGAffineTransform(translationX: 0, y: 188)
            self.homeView.myLocationButton.transform = CGAffineTransform(translationX: 0, y: 105)
        }
    }
}

// MARK: - CLLocation Protocol

extension HomeViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
    }
    
    // 사용자의 위치를 가지고 오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("😡 사용자의 위치를 가져오지 못했습니다.")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
}

// MARK: - 위치 서비스 활성화 체크

extension HomeViewController {
    /*
     환경설정 -> 개인 정보 보호 -> 위치 서비스가 켜져있다면 요청이 가능하고,
     꺼져 있다면 custom alert으로 상황을 알려줘야 한다.
     꺼져 있으면 어떤 앱에서도 위치 서비스를 사용하고 있지 않는 상황이고,
     사용자가 이 위치 서비스를 사용하고 있지 않는 걸 사용자도 모르고 있을 수 있기 때문
     */
    func checkUserDeviceLocationServiceAuthorization() {
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
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
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
            updateCurrentLocation()
            
        default: print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
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

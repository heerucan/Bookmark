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
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        super.configureLayout()
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
    
    private func setupDelegate() {
        locationManager.delegate = self
        homeView.mapView.touchDelegate = self
    }
    
    private func updateCurrentLocation() {
        guard let latitude = locationManager.location?.coordinate.latitude,
              let longtitude = locationManager.location?.coordinate.longitude else { return }
        
        let nmgLatLng = NMGLatLng(lat: latitude, lng: longtitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: nmgLatLng)
        cameraUpdate.animation = .easeIn
        homeView.mapView.moveCamera(cameraUpdate)
    }
    
    private func setupMarker() {
        let nmgLatLng = NMGLatLng(lat: testLatitude, lng: testLongtitude)
        let marker = NMFMarker()
        marker.position = nmgLatLng
        marker.iconImage = NMFOverlayImage(name: "icnLike")
        marker.mapView = homeView.mapView
    }
    
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

// MARK: - NMFMapView Protocol

extension HomeViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        UIView.animate(withDuration: 0.4) {
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




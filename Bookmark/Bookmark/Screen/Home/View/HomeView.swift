//
//  HomeView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

import CoreLocation
import NMapsMap

final class HomeView: BaseView {
    
    // MARK: - Property
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Matrix.cellWidth, height: Matrix.cellHeight-4)
        layout.minimumLineSpacing = Matrix.cellSpacing
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 2, left: Matrix.cellMargin, bottom: 2, right: Matrix.cellMargin)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private let backView = UIView().then {
        $0.makeShadow(radius: 11, offset: CGSize(width: 0, height: 2), opacity: 0.3)
    }
    
    lazy var searchButton = UIButton().then {
        $0.addSubviews([searchLabel, searchIconView])
        $0.backgroundColor = Color.gray500
        $0.makeCornerStyle(width: 0, color: nil, radius: 5)
    }
    
    private let searchIconView = UIImageView().then {
        $0.image = Icon.Image.search
    }
    
    private let searchLabel = UILabel().then {
        $0.text = "책방을 검색해주세요"
        $0.textColor = Color.gray200
        $0.font = Font.body5.font
    }
    
    lazy var mapView = NMFMapView(frame: self.frame).then {
        $0.minZoomLevel = 9.5
        $0.maxZoomLevel = 16
        $0.positionMode = .direction
        $0.locationOverlay.hidden = false
        $0.locationOverlay.circleColor = Color.main.withAlphaComponent(0)
    }
    
    lazy var storeButton = UIButton().then {
        $0.addSubviews([nameLabel, addressLabel, distanceLabel])
        $0.backgroundColor = .white
        $0.makeShadow(radius: 11, offset: CGSize(width: 0, height: -2), opacity: 0.2)
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    let nameLabel = UILabel().then {
        $0.font = Font.body1.font
        $0.textColor = Color.main
        $0.numberOfLines = 1
    }
    
    private let addressLabel = UILabel().then {
        $0.font = Font.body8.font
        $0.textColor = Color.gray100
        $0.numberOfLines = 1
    }
    
    private let distanceLabel = UILabel().then {
        $0.font = Font.body7.font
        $0.textColor = Color.black100
        $0.numberOfLines = 1
        $0.textAlignment = .right
    }
    
    let locationButton = UIButton().then {
        $0.setImage(Icon.Button.myLocation, for: .normal)
        $0.setImage(Icon.Button.highlightedMyLocation, for: .highlighted)
        $0.makeShadow(radius: 11, offset: CGSize(width: 0, height: 0), opacity: 0.25)
    }
        
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([backView,
                          searchButton,
                          collectionView,
                          mapView,
                          locationButton,
                          storeButton])
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(mapView.snp.top)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        searchIconView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(searchIconView.snp.trailing).offset(8)
            make.bottom.equalToSuperview().inset(9)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }

        storeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(89)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(23)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(23)
            make.width.equalTo(250)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(addressLabel.snp.centerY)
            make.width.equalTo(50)
        }
        
        locationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(storeButton.snp.top).offset(-20)
        }
    }
    
    func setupMapDelegate(_ touchDelegate: NMFMapViewTouchDelegate,
                          _ cameraDelegate: NMFMapViewCameraDelegate) {
        mapView.touchDelegate = touchDelegate
        mapView.addCameraDelegate(delegate: cameraDelegate)
    }
    
    func setupCollectionViewDelegate(_ delegate: UICollectionViewDelegate,
                                     _ dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.register(
            HomeTagCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeTagCollectionViewCell.identifier)
    }
    
    // MARK: - @objc
    
    @objc func touchupTagButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    // MARK: - Set Up Data
    
    func setupData(data: BookStoreInfo, distance: Double) {
        nameLabel.text = data.name
        addressLabel.text = data.address
        distanceLabel.text = "\(round((distance/1000)*10)/10)km"
    }
}

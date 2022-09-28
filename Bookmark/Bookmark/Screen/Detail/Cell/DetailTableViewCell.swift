//
//  DetailTableViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

import NMapsMap
import SafariServices

final class DetailTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    weak var safariViewDelegate: SafariViewDelegate?
    
    private var bookStore = ""
    private var phoneNumber = ""
    private var homepage = ""
    private var sns = ""
    
    private let storeTitleLabel = UILabel().then {
        $0.text = "책방 상세정보"
        $0.font = Font.title2.font
    }
    
    private let typeSubLabel = UILabel().then {
        $0.text = "책방 타입"
    }
    
    private let addressSubLabel = UILabel().then {
        $0.text = "책방 주소"
    }
    
    private let typeLabel = UILabel()
    private let addressLabel = UILabel()
    
    private let cloneButton = UIButton().then {
        $0.setImage(Icon.Button.clone, for: .normal)
        $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
    }
    
    private lazy var typeStackView = UIStackView(arrangedSubviews: [typeSubLabel, typeLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fill
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [phoneButton, homePageButton, snsButton]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    private let phoneButton = BookmarkDetailButton(.phone)
    private let homePageButton = BookmarkDetailButton(.homepage)
    private let snsButton = BookmarkDetailButton(.sns)
    
    private let lineView = LineView()
    
    private let locationTitleLabel = UILabel().then {
        $0.text = "책방에 가는 방법은"
        $0.font = Font.body2.font
    }
    
    private let mapView = NMFMapView(frame: .zero).then {
        $0.allowsScrolling = false
        $0.allowsZooming = false
        $0.zoomLevel = 13
    }
    
    let mapAppButton = UIButton().then {
        $0.setImage(Icon.Button.goMapApp, for: .normal)
        $0.setImage(Icon.Button.highlightedGoMapApp, for: .highlighted)
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        [storeTitleLabel, locationTitleLabel].forEach {
            $0.textColor = Color.black100
        }
        
        [addressSubLabel, typeSubLabel].forEach {
            $0.textColor = Color.black100
            $0.font = Font.body9.font
        }
        
        [addressLabel, typeLabel].forEach {
            $0.textColor = Color.black100
            $0.font = Font.body4.font
        }
        
        [phoneButton, homePageButton, snsButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
        }
        
        addressLabel.numberOfLines = 1
    }
    
    override func configureLayout() {
        super.configureLayout()
        contentView.addSubviews([storeTitleLabel,
                                 typeStackView,
                                 addressSubLabel,
                                 addressLabel,
                                 cloneButton,
                                 stackView,
                                 lineView,
                                 locationTitleLabel,
                                 mapView,
                                 mapAppButton])
        
        storeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().inset(16)
        }
        
        typeStackView.snp.makeConstraints { make in
            make.top.equalTo(storeTitleLabel.snp.bottom).offset(22)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        addressSubLabel.snp.makeConstraints { make in
            make.top.equalTo(typeStackView.snp.bottom).offset(17)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(typeSubLabel.snp.trailing)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.leading.equalTo(addressSubLabel.snp.trailing).offset(12)
            make.centerY.equalTo(addressSubLabel.snp.centerY)
            make.trailing.lessThanOrEqualToSuperview().inset(36)
        }
        
        cloneButton.snp.makeConstraints { make in
            make.centerY.equalTo(addressLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(68)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        locationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(35)
            make.leading.equalToSuperview().inset(16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(locationTitleLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(mapView.snp.width).multipliedBy(0.7)
            make.bottom.equalToSuperview().inset(150)
        }
        
        mapAppButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top).inset(10)
            make.trailing.equalTo(mapView.snp.trailing).inset(10)
            make.width.height.equalTo(40)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupButton(_ sender: UIButton) {
        switch sender {
        case phoneButton:
            if let phone = EndPoint.phone.makeURL(phoneNumber),
               UIApplication.shared.canOpenURL(phone) {
                UIApplication.shared.open(phone, options: [:], completionHandler: nil)
            }
            
        case cloneButton:
            guard let address = addressLabel.text else { return }
            UIPasteboard.general.string = address
            showToast(message: Matrix.clipboard)
            
        case homePageButton:
            guard let homepage = EndPoint.safari.makeURL(homepage) else { return }
            let homepageViewController = SFSafariViewController(url: homepage)
            safariViewDelegate?.presentSafariView(homepageViewController)
            
        case snsButton:
            guard let sns = EndPoint.safari.makeURL(sns) else { return }
            let snsViewController = SFSafariViewController(url: sns)
            safariViewDelegate?.presentSafariView(snsViewController)
            
        default:
            break
        }
    }
    
    // MARK: - Set Up Data
    
    func setupMapView(data: BookStoreInfo?) {
        guard let data = data,
              let latitude = Double(data.latitude),
              let longtitude = Double(data.longtitude) else { return }
        let coordinate = NMGLatLng(lat: latitude, lng: longtitude)
        let marker = NMFMarker()
        marker.captionText = data.name
        marker.captionTextSize = 15
        marker.position = coordinate
        marker.width = Matrix.markerSize
        marker.height = Matrix.markerSize
        marker.iconImage = NMFOverlayImage(name: Icon.Image.marker)
        marker.mapView = mapView
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longtitude)))
    }
    
    func setupData(data: BookStoreInfo?) {
        guard let data = data else { return }
        bookStore = data.name.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        phoneNumber = data.phone
        homepage = data.homeURL
        sns = data.sns
        
        storeTitleLabel.text = data.name
        typeLabel.text = data.typeName
        addressLabel.text = data.address
        
        homePageButton.isDisabled = (data.homeURL == "") ? true : false
        snsButton.isDisabled = (data.sns == "") ? true : false
        phoneButton.isDisabled = (data.phone.replacingOccurrences(of: " ", with: "") == "") ? true : false
    }
}

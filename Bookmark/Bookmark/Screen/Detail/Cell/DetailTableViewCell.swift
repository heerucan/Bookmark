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
        
    private let infoTitleLabel = UILabel().then {
        $0.text = "책방 상세정보"
    }
    
    private let locationTitleLabel = UILabel().then {
        $0.text = "책방 위치"
    }
    
    private lazy var detailView = UIView().then {
        $0.addSubview(cloneButton)
    }
    
    private lazy var detailStackView = UIStackView(
        arrangedSubviews: [typeLabel, phoneButton, addressLabel]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .equalSpacing
        }
    
    private let cloneButton = UIButton().then {
        $0.setImage(Icon.Button.clone, for: .normal)
        $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
    }

    private let typeLabel = UILabel()
    private let addressLabel = UILabel()
    private let urlView = UIView()
    
    private lazy var urlStackView = UIStackView(
        arrangedSubviews: [homePageButton, snsButton]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .equalSpacing
        }
    
    private let phoneButton = BookmarkLinkButton(.phone)
    private let homePageButton = BookmarkLinkButton(.url)
    private let snsButton = BookmarkLinkButton(.url)
    
    private let mapView = NMFMapView(frame: .zero).then {
        $0.allowsScrolling = false
        $0.allowsZooming = false
        $0.zoomLevel = 13
    }
    
    private let mapAppButton = UIButton().then {
        $0.setImage(Icon.Button.goMapApp, for: .normal)
        $0.setImage(Icon.Button.highlightedGoMapApp, for: .highlighted)
        $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        [detailView, urlView, mapView].forEach {
            $0.backgroundColor = Color.gray500
            $0.makeCornerStyle(width: 0, color: nil, radius: 5)
        }
        
        [infoTitleLabel, locationTitleLabel].forEach {
            $0.font = Font.body2.font
            $0.textColor = Color.black100
        }
        
        [addressLabel, typeLabel].forEach {
            $0.textColor = Color.gray100
            $0.font = Font.body7.font
            $0.isUserInteractionEnabled = true
        }
        
        [phoneButton, homePageButton, snsButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        contentView.addSubviews([infoTitleLabel,
                                 detailView,
                                 detailStackView,
                                 urlView,
                                 urlStackView,
                                 locationTitleLabel,
                                 mapView,
                                 mapAppButton])
        
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().inset(16)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(detailStackView.snp.bottom).offset(-16)
        }
        
        detailStackView.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.top).inset(20)
            make.trailing.equalTo(detailView.snp.trailing).inset(45)
            make.leading.equalTo(detailView.snp.leading).inset(20)
            make.bottom.equalTo(detailView.snp.bottom).inset(20)
        }
        
        urlView.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(urlStackView.snp.bottom).offset(-16)
        }
        
        urlStackView.snp.makeConstraints { make in
            make.top.equalTo(urlView.snp.top).inset(20)
            make.leading.equalTo(urlView.snp.leading).inset(20)
            make.bottom.equalTo(urlView.snp.bottom).inset(20)
            make.trailing.equalTo(urlView.snp.trailing).inset(20)
        }
        
        locationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(urlView.snp.bottom).offset(35)
            make.leading.equalToSuperview().inset(16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(locationTitleLabel.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(mapView.snp.width).multipliedBy(1)
            make.bottom.equalToSuperview().inset(150)
        }
        
        mapAppButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top).inset(15)
            make.trailing.equalTo(mapView.snp.trailing).inset(15)
        }
        
        cloneButton.snp.makeConstraints { make in
            make.centerY.equalTo(addressLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
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
            
        case mapAppButton:
            guard let naver = EndPoint.naver.makeURL(bookStore) else { return }
            guard let appStore = EndPoint.appstore.makeURL() else { return }
            if UIApplication.shared.canOpenURL(naver) {
                UIApplication.shared.open(naver)
            } else {
                UIApplication.shared.open(appStore)
            }
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
        typeLabel.text = "책방타입    \(data.typeName)"
        addressLabel.text = "책방주소    \(data.address)"
        phoneButton.setTitle("전화번호    \(data.phone)", for: .normal)
        homePageButton.setTitle("홈페이지    \(data.homeURL)", for: .normal)
        snsButton.setTitle("SNS    \(data.sns)", for: .normal)
        
        phoneButton.addLinkStyle(.phone, range: data.phone)
        homePageButton.addLinkStyle(.url, range: data.homeURL)
        snsButton.addLinkStyle(.url, range: data.sns)
        
        homePageButton.isHidden = (data.homeURL == "") ? true : false
        snsButton.isHidden = (data.sns == "") ? true : false
        phoneButton.isHidden = (data.phone.replacingOccurrences(of: " ", with: "") == "") ? true : false
        
        if data.homeURL == "" && data.sns == "" {
            urlView.isHidden = true
            locationTitleLabel.snp.remakeConstraints { make in
                make.top.equalTo(detailView.snp.bottom).offset(35)
                make.leading.equalToSuperview().inset(16)
            }
        } else {
            urlView.isHidden = false
        }
    }
}

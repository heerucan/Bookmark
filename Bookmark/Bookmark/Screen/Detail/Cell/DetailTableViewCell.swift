//
//  DetailTableViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

import NMapsMap

final class DetailTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    private let firstTitleLabel = UILabel().then {
        $0.text = "책방 상세정보"
    }
    
    private let secondTitleLabel = UILabel().then {
        $0.text = "책방 위치"
    }
    
    private lazy var detailView = UIView().then {
        $0.addSubview(cloneButton)
    }
    
    private lazy var detailStackView = UIStackView(
        arrangedSubviews: [addressLabel, phoneLabel, typeLabel]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .equalSpacing
        }
    
    let cloneButton = UIButton().then {
        $0.setImage(Icon.Button.clone, for: .normal)
    }
    
    private let addressLabel = UILabel()
    private let phoneLabel = UILabel()
    private let typeLabel = UILabel()
    
    private let urlView = UIView()
    
    private lazy var urlStackView = UIStackView(
        arrangedSubviews: [homePageLabel, snsLabel]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .equalSpacing
        }
    
    private let homePageLabel = UILabel()
    private let snsLabel = UILabel()
    
    private lazy var mapView = NMFMapView(frame: frame).then {
        $0.addSubview(mapAppButton)
        $0.allowsScrolling = false
        $0.locationOverlay.hidden = true
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
        [detailView, urlView, mapView].forEach {
            $0.backgroundColor = Color.gray500
            $0.makeCornerStyle(width: 0, color: nil, radius: 5)
        }
        
        [firstTitleLabel, secondTitleLabel].forEach {
            $0.font = Font.body2.font
            $0.textColor = Color.black100
        }
        
        [addressLabel, phoneLabel, typeLabel, homePageLabel, snsLabel].forEach {
            $0.textColor = Color.gray100
            $0.font = Font.body8.font
            $0.numberOfLines = 2
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        contentView.addSubviews([firstTitleLabel,
                                 detailView,
                                 detailStackView,
                                 urlView,
                                 urlStackView,
                                 secondTitleLabel,
                                 mapView])
        
        firstTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().inset(16)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(firstTitleLabel.snp.bottom).offset(16)
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
        
        secondTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(urlView.snp.bottom).offset(35)
            make.leading.equalToSuperview().inset(16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(secondTitleLabel.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(mapView.snp.width).multipliedBy(0.7)
            make.bottom.equalToSuperview().inset(150)
        }
        
        mapAppButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(15)
        }
        
        cloneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Custom Method
    
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
    
    // MARK: - Set Up Data
    
    func setupData(data: BookStoreInfo?) {
        guard let data = data else { return }
        addressLabel.text = "상세주소    \(data.address)"
        phoneLabel.text = "전화번호    \(data.phone)"
        typeLabel.text = "책방타입    \(data.typeName)"
        homePageLabel.text = "홈페이지    \(data.homeURL)"
        snsLabel.text = "SNS    \(data.sns)"

        homePageLabel.isHidden = (data.homeURL == "") ? true : false
        snsLabel.isHidden = (data.sns == "") ? true : false
        phoneLabel.isHidden = (data.phone == "") ? true : false
        
        if data.homeURL == "" && data.sns == "" {
            urlView.isHidden = true
            secondTitleLabel.snp.remakeConstraints { make in
                make.top.equalTo(detailView.snp.bottom).offset(35)
                make.leading.equalToSuperview().inset(16)
            }
        } else {
            urlView.isHidden = false
        }
    }
}


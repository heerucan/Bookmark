//
//  HomeView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

import NMapsMap

final class HomeView: BaseView {
    
    // MARK: - Property
    
    lazy var transitionButton = UIButton().then {
        $0.addSubviews([searchLabel, searchIconView])
        $0.backgroundColor = Color.gray500
        $0.makeCornerStyle(width: 0, color: nil, radius: 5)
    }
    
    private let searchIconView = UIImageView().then {
        $0.image = Icon.Image.search
    }
    
    private let searchLabel = UILabel().then {
        $0.text = "책방을 검색해주세요"
        $0.textColor = Color.gray300
        $0.font = Font.body5.font
    }
        
    private lazy var tagStackView = UIStackView(arrangedSubviews: [
        bookmarkButton, newStoreButton, oldStoreButton]).then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .equalSpacing
        }
    
    let bookmarkButton = TagButton(.bookmark).then {
        $0.isSelected = false
    }
    
    let newStoreButton = TagButton(.category).then {
        $0.tagLabel.text = "새책방"
        $0.isSelected = false
    }
    
    let oldStoreButton = TagButton(.category).then {
        $0.tagLabel.text = "헌책방"
        $0.isSelected = false
    }
    
    lazy var mapView = NMFMapView(frame: self.frame)
    
    let findButton = TagButton(.location).then {
        $0.tagLabel.text = "현 지도에서 검색"
        $0.isSelected = false
        $0.makeShadow(radius: 4, offset: CGSize(width: 0, height: 3), opacity: 0.25)
    }
    
    lazy var storeButton = UIButton().then {
        $0.addSubviews([nameLabel, addressLabel, distanceLabel])
        $0.backgroundColor = .white
        $0.makeCornerStyle(width: 0, color: nil, radius: 10)
        $0.makeShadow(radius: 37, offset: CGSize(width: 2, height: 2), opacity: 0.1)
    }
    
    let nameLabel = UILabel().then {
        $0.font = Font.body1.font
        $0.text = "북카페 파오"
        $0.textColor = Color.green100
        $0.numberOfLines = 1
    }
    
    let addressLabel = UILabel().then {
        $0.font = Font.body8.font
        $0.text = "서울 서대문구 대현동 201 럭키 아파트 2층 상가"
        $0.textColor = Color.gray100
        $0.numberOfLines = 1
    }
    
    let distanceLabel = UILabel().then {
        $0.font = Font.body7.font
        $0.text = "3km"
        $0.textColor = Color.black100
        $0.numberOfLines = 1
        $0.textAlignment = .right
    }
    
    let myLocationButton = UIButton().then {
        $0.setImage(Icon.Button.myLocation, for: .normal)
        $0.setImage(Icon.Button.highlightedMyLocation, for: .highlighted)
        $0.makeShadow(radius: 14, offset: CGSize(width: 0, height: 0), opacity: 0.15)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([transitionButton,
                          tagStackView,
                          mapView,
                          findButton,
                          myLocationButton,
                          storeButton])
        
        transitionButton.snp.makeConstraints { make in
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
        
        tagStackView.snp.makeConstraints { make in
            make.top.equalTo(transitionButton.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(38)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(tagStackView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        findButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top).inset(12)
            make.centerX.equalToSuperview()
        }
        
        storeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
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
            make.width.equalTo(45)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(storeButton.snp.top).offset(-20)
        }
    }
}

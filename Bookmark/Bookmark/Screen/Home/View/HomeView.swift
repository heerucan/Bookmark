//
//  HomeView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/13.
//

import UIKit

final class HomeView: BaseView {
    
    // MARK: - Property
    
    private lazy var searchBackView = UIView().then {
        $0.addSubviews([searchBar, searchIconView])
        $0.backgroundColor = Color.gray500
        $0.makeCornerStyle(width: 0, color: nil, radius: 5)
    }
    
    private let searchIconView = UIImageView().then {
        $0.image = Icon.Image.search
    }
    
    private let searchBar = UISearchBar()
    
    private lazy var tagStackView = UIStackView(arrangedSubviews: [
        bookmarkButton, newStoreButton, oldStoreButton]).then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .equalSpacing
        }
    
    let bookmarkButton = TagButton(.bookmark).then {
        $0.isUnselected = true
    }
    
    let newStoreButton = TagButton(.category).then {
        $0.tagLabel.text = "새책방"
        $0.isUnselected = true
    }
    
    let oldStoreButton = TagButton(.category).then {
        $0.tagLabel.text = "헌책방"
        $0.isUnselected = true
    }
    
    let mapView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    
    let findButton = TagButton(.location).then {
        $0.tagLabel.text = "현 지도에서 검색"
        $0.isUnselected = true
        // MARK: - 그림자
    }
    
    private lazy var storeView = UIView().then {
        $0.addSubviews([nameLabel, addressLabel, distanceLabel])
        $0.backgroundColor = .white
        $0.makeCornerStyle(width: 0, color: nil, radius: 10)
        // MARK: - 그림자
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
        // MARK: - 그림자
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSearchBar()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func configureLayout() {
        self.addSubviews([searchBackView,
                          tagStackView,
                          mapView,
                          findButton,
                          myLocationButton,
                          storeView])
        
        searchBackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        searchIconView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(searchIconView.snp.trailing).inset(10)
        }
        
        tagStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBackView.snp.bottom).offset(12)
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
        
        storeView.snp.makeConstraints { make in
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
            make.bottom.equalTo(storeView.snp.top).offset(-20)
        }
    }
    
    // MARK: - Custom Method
    
    private func setupSearchBar() {
        searchBar.clipsToBounds = true
        searchBar.tintColor = Color.black100
        searchBar.backgroundColor = Color.gray500
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = Color.gray500
        searchBar.searchTextField.textColor = Color.black100
        searchBar.searchTextField.font = Font.body5.font
        searchBar.makeCornerStyle(width: 0, color: nil, radius: 5)
        let attributedString = NSMutableAttributedString(
            string: "책방을 검색해주세요",
            attributes: [.foregroundColor: Color.gray300,
                         .font: Font.body5.font])
        searchBar.searchTextField.attributedPlaceholder = attributedString
        searchBar.searchTextField.leftView = .none
    }
}

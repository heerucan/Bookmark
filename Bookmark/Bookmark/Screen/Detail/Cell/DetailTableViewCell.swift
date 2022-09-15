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
        arrangedSubviews: [addressLabel, phoneLabel, timeLabel, restLabel]).then {
            $0.axis = .vertical
            $0.spacing = 12
            $0.distribution = .equalSpacing
        }
    
    let cloneButton = UIButton().then {
        $0.setImage(Icon.Button.clone, for: .normal)
    }
    
    private let addressLabel = UILabel().then {
        $0.text = "광주광역시 서대문구 대현동 201 럭키 아파트 2층 상가50"
    }
    
    private let phoneLabel = UILabel().then {
        $0.text = "전화번호    0507-0989-1232"
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "운영시간    평일 12:00 - 22:00 | 주말 12:00 - 20:00"
    }
    
    private let restLabel = UILabel().then {
        $0.text = "휴무일    월요일, 화요일 휴무"
    }
    
    private let urlView = UIView()
    
    private lazy var urlStackView = UIStackView(
        arrangedSubviews: [homePageLabel, snsLabel]).then {
            $0.axis = .vertical
            $0.spacing = 12
            $0.distribution = .equalSpacing
        }
    
    private let homePageLabel = UILabel().then {
        $0.text = "홈페이지   https://homepagename.com"
    }
    
    private let snsLabel = UILabel().then {
        $0.text = "SNS   instagram.com/heerucan"
    }
    
    private lazy var mapView = NMFMapView(frame: frame).then {
        $0.addSubview(mapAppButton)
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
        
        [addressLabel, phoneLabel, timeLabel,
         restLabel, homePageLabel, snsLabel].forEach {
            $0.textColor = Color.gray100
            $0.font = Font.body8.font
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
            make.height.equalTo(136)
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
            make.height.equalTo(80)
        }
        
        urlStackView.snp.makeConstraints { make in
            make.top.equalTo(urlView.snp.top).inset(20)
            make.leading.equalTo(urlView.snp.leading).inset(20)
            make.bottom.equalTo(urlView.snp.bottom).inset(20)
            make.trailing.equalTo(urlView.snp.trailing).inset(20)
        }
        
        secondTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(urlView.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(secondTitleLabel.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(mapView.snp.width).multipliedBy(1)
            make.bottom.equalToSuperview().inset(100)
        }
        
        mapAppButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(15)
        }
        
        cloneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}


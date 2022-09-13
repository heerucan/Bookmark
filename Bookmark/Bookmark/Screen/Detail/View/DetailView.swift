//
//  DetailView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

final class DetailView: BaseView {
    
    // MARK: - Property
    
    let navigationBar = BookmarkNavigationBar()
    
    private lazy var scrollView = UIScrollView().then {
        $0.alwaysBounceHorizontal = true
        $0.contentSize = CGSize(width: self.frame.width, height: 700)
    }
    
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
        $0.text = "전화번호   0507-0989-1232"
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "운영시간   평일 12:00 - 22:00  |  주말 12:00 - 20:00"
    }
    
    private let restLabel = UILabel().then {
        $0.text = "휴무일   월요일, 화요일 휴무"
    }
    
    private let urlView = UIView()
    
    private lazy var urlStackView = UIStackView(
        arrangedSubviews: [homeLabel, snsLabel]).then {
            $0.axis = .vertical
            $0.spacing = 12
            $0.distribution = .equalSpacing
        }
    
    private let homeLabel = UILabel().then {
        $0.text = "홈페이지   https://homepagename.com"
    }
    
    private let snsLabel = UILabel().then {
        $0.text = "SNS   instagram.com/heerucan"
    }
    
    private lazy var mapView = UIView().then {
        $0.addSubview(mapAppButton)
    }
    
    let mapAppButton = UIButton().then {
        $0.setImage(Icon.Button.goMapApp, for: .normal)
        $0.setImage(Icon.Button.highlightedGoMapApp, for: .highlighted)
    }
    
    private lazy var backView = UIView().then {
        $0.backgroundColor = .white
        $0.addSubviews([writeButton, bookmarkButton])
    }
    
    let writeButton = BookmarkButton(.bookmark).then {
        $0.isDisabled = false
    }
    
    let bookmarkButton = UIButton().then {
        $0.setImage(Icon.Button.bookmark, for: .selected)
        $0.setImage(Icon.Button.unselectedBookmark, for: .normal)
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        [detailView, urlView, mapView].forEach {
            $0.backgroundColor = Color.gray500
            $0.makeCornerStyle(width: 0, color: nil, radius: 5)
        }
        
        [firstTitleLabel, secondTitleLabel].forEach {
            $0.font = Font.body2.font
            $0.textColor = Color.black100
        }
        
        [addressLabel, phoneLabel, timeLabel,
         restLabel, homeLabel, snsLabel].forEach {
            $0.textColor = Color.gray100
            $0.font = Font.body8.font
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        self.addSubviews([navigationBar, scrollView, backView])
        scrollView.addSubviews([firstTitleLabel,
                                detailView,
                                detailStackView,
                                urlView,
                                urlStackView,
                                secondTitleLabel,
                                mapView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
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
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(343)
            make.bottom.equalToSuperview().offset(50)
        }
        
        mapAppButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(15)
        }
        
        cloneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(20)
        }
        
        backView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(95)
        }
        
        writeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(49)
            make.trailing.equalTo(bookmarkButton.snp.leading).offset(-12)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(49)
        }
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}

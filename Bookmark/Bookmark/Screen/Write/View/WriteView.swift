//
//  WriteView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

import RealmSwift

final class WriteView: BaseView {
    
    // MARK: - Realm
    
    let repository = BookmarkRepository.shared
    
    var objectId: ObjectId?
    
    // MARK: - Property
    
    var bookStore: String = "" {
        didSet {
            navigationView.titleLabel.text = bookStore
        }
    }
    
    var image: UIImage? {
        didSet {
            imageButton.setImage(image, for: .normal)
            completeButton.isDisabled = image != nil ? false : true
        }
    }
    
    var writeViewState: WriteViewState = .book {
        didSet {
            descriptionLabel.text = writeViewState.description
            titleTextField.isHidden = writeViewState.isHidden
        }
    }
    
    let navigationView = BookmarkNavigationBar(type: .write)
    
    private let descriptionLabel = UILabel().then {
        $0.font = Font.body3.font
        $0.textColor = Color.black100
    }
    
    lazy var imageButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFill
        $0.backgroundColor = Color.gray300
        $0.addSubview(iconView)
    }
    
    private let iconView = UIImageView().then {
        $0.image = Icon.Image.gallery
    }

    private let imageDescriptionLabel = UILabel().then {
        $0.font = Font.body8.font
        $0.textColor = Color.main
        $0.text = "* 이미지는 추후 수정하실 수 없어요."
    }
    
    let titleTextField = BookmarkTextField().then {
        $0.makeCornerStyle(width: 1, color: Color.gray300.cgColor, radius: 0)
    }
    
    let completeButton = BookmarkButton(.complete).then {
        $0.isDisabled = true
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([navigationView,
                          descriptionLabel,
                          imageButton,
                          imageDescriptionLabel,
                          titleTextField,
                          completeButton])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
        }
        
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(23)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(110)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(16)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(imageDescriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(43)
        }
        
        completeButton.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(15)
            make.height.equalTo(54)
        }
    }
    
    func setupWriteViewState(_ viewStates: WriteViewState) {
        writeViewState = viewStates
    }
}

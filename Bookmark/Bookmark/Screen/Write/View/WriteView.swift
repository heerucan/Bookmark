//
//  WriteView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

final class WriteView: BaseView {
    
    // MARK: - Property
    
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
    
    let descriptionLabel = UILabel().then {
        $0.font = Font.body5.font
        $0.textColor = Color.black100
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [titleTextField, imageButton]).then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 20
    }
    
    var titleTextField = BookmarkTextField().then {
        $0.layer.cornerRadius = 5
        $0.makeCornerStyle(width: 1, color: Color.gray300.cgColor, radius: 5)
    }
    
    lazy var imageButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.makeCornerStyle(width: 1, color: Color.gray300.cgColor, radius: 5)
        $0.addSubview(iconView)
    }
    
    let iconView = UIImageView().then {
        $0.image = Icon.Image.gallery
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
                          stackView,
                          completeButton])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(57)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(25)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(43)
        }
        
        imageButton.snp.makeConstraints { make in
            make.height.equalTo(imageButton.snp.width).multipliedBy(1)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(49)
        }
    }
    
    func setupWriteViewState(_ image: UIImage? = Icon.Button.close,
                             _ viewStates: WriteViewState) {
        navigationView.rightBarButton.setImage(image, for: .normal)
        navigationView.backButton.isHidden = true
        writeViewState = viewStates
    }
}

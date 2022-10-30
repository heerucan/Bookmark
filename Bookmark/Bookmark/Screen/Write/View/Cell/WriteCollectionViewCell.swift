//
//  WriteCollectionViewCell.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/30.
//

import UIKit

final class WriteCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    lazy var imageButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFill
        $0.backgroundColor = Color.gray400
        $0.addSubview(iconView)
    }
    
    let iconView = UIImageView().then {
        $0.image = Icon.Image.gallery
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([imageButton])
        
        imageButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Set Up Data
    
    func setupData(image: UIImage?) {
        imageButton.setImage(image, for: .normal)
    }
}

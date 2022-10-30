//
//  WriteView.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/14.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

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
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())

    private let imageDescriptionLabel = UILabel().then {
        $0.font = Font.body8.font
        $0.textColor = Color.main
        $0.text = Matrix.writeInfoText
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
    
    override func configureUI() {
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func configureLayout() {
        self.addSubviews([navigationView,
                          descriptionLabel,
                          collectionView,
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(23)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
        
        imageDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
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

// MARK: - Composition Layout

extension WriteView {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let spacing = 16.0
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(120),
                heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            switch sectionIndex {
            case 0:
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0, leading: spacing, bottom: 0, trailing: 8)
            default:
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0, leading: 0, bottom: 0, trailing: spacing)
            }
            return section
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = createCompositionalLayout()
        configuration.scrollDirection = .horizontal
        layout.configuration = configuration
        return layout
    }
}

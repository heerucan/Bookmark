//
//  WriteViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import PhotosUI
import RealmSwift

final class WriteViewController: BaseViewController {
    
    // MARK: - Realm
    
    var tasks: Results<Record>! {
        didSet {
            print("Tasks 변화 발생", tasks as Any)
        }
    }
    
    var objectId: ObjectId?
    
    // MARK: - Property
    
    let writeView = WriteView()
    var bookmarkViewStatus: ViewStatus = .write
    private var dataSource: UICollectionViewDiffableDataSource<Int, UIImage?>?

    var fromWhatView: FromWhatView = .detail {
        didSet {
            writeView.navigationView.rightButton.isHidden = fromWhatView.rightButtonIsHidden
            writeView.navigationView.leftButton.isHidden = fromWhatView.leftButtonIsHidden
        }
    }
    
    var bookmark: Bool = false
    
    var photoList: [UIImage] = [] {
        didSet {
            writeView.completeButton.isDisabled = photoList.count == 0 ? true : false
        }
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        configureDataSource()
        applySnapshot(photoList)
    }
    
    override func configureUI() {
        super.configureUI()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Configure UI & Layout
    
    override func setupDelegate() {
        writeView.titleTextField.delegate = self
    }
    
    // MARK: - Custom Method
    
    private func setupAction() {
        writeView.completeButton.addTarget(self, action: #selector(touchupCompleteButton(sender:)), for: .touchUpInside)
        writeView.navigationView.rightButton.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
        writeView.navigationView.leftButton.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
    }
    
    private func setupPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        transition(picker, .present)
    }
    
    private func setupImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        transition(picker, .present)
    }
    
    // MARK: - @objc
    
    @objc func touchupImageButton() {
        let camera = UIAlertAction(title: "카메라 촬영", style: .default) { _ in
            self.setupImagePicker()
        }
        let photo = UIAlertAction(title: "갤러리 선택", style: .default) { _ in
            self.setupPhotoPicker()
        }
        showAlert(title: "갤러리/카메라 접근",
                  actions: [camera, photo],
                  preferredStyle: .actionSheet)
    }
    
    @objc func touchupCompleteButton(sender: UIButton) {
        guard let title = writeView.titleTextField.text,
              // MARK: - TODO 여기 사진 여러장을 하나씩 FileManager에 저장해야 함
              let image = photoList.first else { return }
        if writeView.writeViewState == .book { // 글귀면 true
            let detailTask = Record(store: Store(name: writeView.bookStore, bookmark: bookmark),
                                    title: title,
                                    category: false,
                                    createdAt: Date())
            writeView.repository.addRecord(item: detailTask)
            FileManagerHelper.shared.saveImageToDocument(fileName: "\(detailTask.objectId).jpg", image: image)
            fromWhatView == .detail ? transition(self, .pop) : transition(self, .dismiss)
        } else if writeView.writeViewState == .sentence { // 책이면 false
            if bookmarkViewStatus == .edit { // 수정하기는 무조건 탭바 -> 모달 -> disimiss
                guard let objectId = objectId else { return }
                writeView.repository.updateRecord(item:["objectId": objectId,
                                                        "Store": Store(name: writeView.bookStore, bookmark: bookmark),
                                                        "title": title,
                                                        "category": true,
                                                        "createdAt": Date()])
                transition(self, .dismiss)
            } else { // 글쓰기
                let bookmarkTask = Record(store: Store(name: writeView.bookStore, bookmark: bookmark),
                                          title: title,
                                          category: true,
                                          createdAt: Date())
                writeView.repository.addRecord(item: bookmarkTask)
                FileManagerHelper.shared.saveImageToDocument(fileName: "\(bookmarkTask.objectId).jpg", image: image)
                fromWhatView == .detail ? transition(self, .pop) : transition(self, .dismiss)
            }
        }
    }
    
    @objc private func touchupButton(_ sender: UIButton) {
        let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
            switch sender {
            case self.writeView.navigationView.leftButton:
                return self.transition(self, .pop)
            case self.writeView.navigationView.rightButton:
                return self.transition(self, .dismiss)
            default:
                break
            }
        }
        showAlert(title: Matrix.backPopupTitle,
                  message: Matrix.backPopupMessage,
                  actions: [ok],
                  preferredStyle: .alert)
    }
    
    @objc override func keyboardWillShow(_ notification: NSNotification) {
        super.keyboardWillShow(notification)
        let offset = 20.0
        UIView.animate(withDuration: 0.1) {
            self.writeView.completeButton.transform = CGAffineTransform(translationX: 0, y: offset-(self.keyboardHeight))
        }
    }
}

// MARK: - DiffableDataSource

extension WriteViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<WriteCollectionViewCell, UIImage?> { cell, IndexPath, itemIdentifier in
            switch IndexPath.section {
            case 1:
                cell.imageButton.isUserInteractionEnabled = false
                cell.iconView.isHidden = true
            default:
                break
            }
            cell.setupData(image: itemIdentifier)
            cell.imageButton.addTarget(self, action: #selector(self.touchupImageButton), for: .touchUpInside)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: writeView.collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func applySnapshot(_ items: [UIImage?]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UIImage?>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems([UIImage()], toSection: 0)
        snapshot.appendItems(items, toSection: 1)
        dataSource?.apply(snapshot)
    }
}

// MARK: - TextField Delegate

extension WriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        writeView.titleTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        writeView.titleTextField.isSelected = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        writeView.titleTextField.isSelected = false
        UIView.animate(withDuration: 0.25) {
            self.writeView.completeButton.transform = .identity
        }
    }
}

// MARK: - PHPickerDelegate / UIImagePickerDelegate / UINavigationDelegate

extension WriteViewController: PHPickerViewControllerDelegate,
                                UINavigationControllerDelegate,
                                UIImagePickerControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.transition(self, .dismiss)
        
        if !results.isEmpty {
            photoList.removeAll()

            results.forEach { result in
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
                        DispatchQueue.main.async {
                            guard let self = self else { return }
                            self.photoList.append(image as! UIImage)
                            self.applySnapshot(self.photoList)
                        }
                    }
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.transition(self, .dismiss)
            return
        }
        if !photoList.isEmpty {
            photoList.removeAll()
        }
        self.photoList.append(image)
        self.applySnapshot(self.photoList)
        picker.transition(self, .dismiss)
    }
}

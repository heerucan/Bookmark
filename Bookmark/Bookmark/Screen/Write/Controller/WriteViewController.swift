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
    
    var fromWhatView: FromWhatView = .detail {
        didSet {
            writeView.navigationView.rightButton.isHidden = fromWhatView.rightButtonIsHidden
            writeView.navigationView.leftButton.isHidden = fromWhatView.leftButtonIsHidden
        }
    }
    
    var bookmarkViewStatus: ViewStatus = .write
    
    var bookmark: Bool = false
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
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
        writeView.imageButton.addTarget(self, action: #selector(touchupImageButton), for: .touchUpInside)
        writeView.completeButton.addTarget(self, action: #selector(touchupCompleteButton(sender:)), for: .touchUpInside)
        writeView.navigationView.rightButton.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
        writeView.navigationView.leftButton.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
    }
    
    private func setupPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        transition(picker, .present)
        self.present(picker, animated: true)
    }
    
    private func setupImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    // MARK: - @objc
    
    @objc func touchupImageButton() {
        let camera = UIAlertAction(title: "Camera".localized, style: .default) { _ in
            self.setupImagePicker()
        }
        let photo = UIAlertAction(title: "Photo".localized, style: .default) { _ in
            self.setupPhotoPicker()
        }
        showAlert(title: "imageActionSheetTitle".localized,
                  actions: [camera, photo],
                  preferredStyle: .actionSheet)
    }
    
    @objc func touchupCompleteButton(sender: UIButton) {
        guard let title = writeView.titleTextField.text,
              let image = writeView.imageButton.imageView?.image else { return }
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
        let ok = UIAlertAction(title: "ok".localized, style: .destructive) { _ in
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

// MARK: - PHPicker / UIImagePicker / UINavigation Protocol

extension WriteViewController: PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) {
            if let itemProvider = results.first?.itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, err) in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.writeView.image = image as? UIImage
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
        self.writeView.image = image
        picker.transition(self, .dismiss)
    }
}

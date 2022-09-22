//
//  WriteViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

import PhotosUI

final class WriteViewController: BaseViewController {
    
    // MARK: - Property
    
    let writeView = WriteView()
    
    var fromWhatView: FromWhatViewType = .detail
    var viewType: FromWhatViewType = .write
    
    var bookStore: String = ""
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
        writeView.navigationView.rightBarButton.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
        writeView.navigationView.backButton.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
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
        let camera = UIAlertAction(title: "카메라 촬영", style: .default) { _ in
            self.setupImagePicker()
        }
        let photo = UIAlertAction(title: "갤러리 선택", style: .default) { _ in
            self.setupPhotoPicker()
        }
        showAlert(title: "갤러리/카메라 접근",
                  message: nil,
                  actions: [camera, photo],
                  preferredStyle: .actionSheet)
    }
    
    @objc func touchupCompleteButton(sender: UIButton) {
        
        // MARK: - TODO 수정 분기처리는 어떻게 하지?
        guard let title = writeView.titleTextField.text else { return }
        
        if fromWhatView == .detail { // 디테일이면 true
            
            // 글작성
            let detailTask = Record(store: Store(name: bookStore, bookmark: bookmark),
                              title: title,
                              image: nil,
                              category: true,
                              createdAt: Date())
            writeView.repository.addRecord(item: detailTask)
            transition(self, .pop)
            
        } else if fromWhatView == .bookmark { // 책갈피면 false
            
            // 글작성
            let bookmarkTask = Record(store: Store(name: bookStore, bookmark: bookmark),
                              title: title,
                              image: nil,
                              category: false,
                              createdAt: Date())
            writeView.repository.addRecord(item: bookmarkTask)
            transition(self, .dismiss)
        }
        
        if let image = writeView.imageButton.imageView?.image {
            
        } else {
//            guard let
        }
    }
    
    @objc private func touchupButton(_ sender: UIButton) {
        let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
            switch sender {
            case self.writeView.navigationView.backButton:
                return self.transition(self, .pop)
            case self.writeView.navigationView.rightBarButton:
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
}

// MARK: - TextField Delegate

extension WriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        writeView.titleTextField.resignFirstResponder()
        return true
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

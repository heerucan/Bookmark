//
//  PhraseViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/21.
//

import UIKit

final class PhraseViewController: BaseViewController {
    
    // MARK: - Property
    
    let phraseView = PhraseView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = phraseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phraseView.fetchRealm()
    }
    
    // MARK: - Configure UI & Layout
    
    override func setupDelegate() {
        phraseView.configureTableViewDelegate(self, self)
    }
    
    // MARK: - @objc
    
    @objc func touchupMoreButton(sender: UIButton) {
        let share = UIAlertAction(title: "공유하고 싶어요", style: .default) { _ in
            guard let cell = self.phraseView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))
                    as? BookmarkPhraseTableViewCell else { return }
            
            if let instaURL = EndPoint.instagram.makeURL() {
                if UIApplication.shared.canOpenURL(instaURL) {
                    let renderer = UIGraphicsImageRenderer(size: cell.contentView.bounds.size)
                    let renderImage = renderer.image { _ in
                        cell.contentView.drawHierarchy(in: cell.contentView.bounds, afterScreenUpdates: true)
                    }
                    guard let imageData = renderImage.pngData() else { return }
                    
                    let pasteboardItems: [String: Any] = [
                        "com.instagram.sharedSticker.stickerImage": imageData,
                        "com.instagram.sharedSticker.backgroundTopColor": "#ffffff",
                        "com.instagram.sharedSticker.backgroundBottomColor": "#ffffff",
                    ]
                    let pasteboardOptions = [
                        UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                    ]
                    UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                    UIApplication.shared.open(instaURL, options: [:], completionHandler: nil)
                } else {
                    self.showAlert(title: "인스타그램이 없네요 :(", message: nil, actions: [])
                }
            }
        }
        let edit = UIAlertAction(title: "수정하고 싶어요", style: .default) { _ in
            let viewController = WriteViewController()
            self.transition(viewController, .present) { _ in
                viewController.writeView.setupWriteViewState(.sentence)
                viewController.fromWhatView = .bookmark
                viewController.bookmarkViewStatus = .edit
                viewController.objectId = self.phraseView.tasks[sender.tag].objectId
                viewController.writeView.completeButton.setTitle("수정", for: .normal)
                
                // 수정하기 화면으로 데이터 전달
                let image = FileManagerHelper.shared.loadImageFromDocument(fileName: "\(self.phraseView.tasks[sender.tag].objectId).jpg")
                viewController.writeView.imageButton.setImage(image, for: .normal)
                viewController.writeView.titleTextField.text = self.phraseView.tasks[sender.tag].title
                viewController.writeView.imageButton.isUserInteractionEnabled = false
                viewController.writeView.completeButton.isDisabled = false
            }
        }
        let delete = UIAlertAction(title: "지우고 싶어요", style: .default) { _ in
            self.phraseView.repository.deleteRecord(record: self.phraseView.tasks[sender.tag],
                                                    store: self.phraseView.tasks[sender.tag].store ?? Store())
            NotificationCenter.default.post(name: NSNotification.Name("countPhrase"), object: sender.tag)
            self.phraseView.fetchRealm()
        }
        showAlert(title: "꽂은 책갈피를",
                  message: nil,
                  actions: [share, edit, delete],
                  cancelTitle: "그대로 둘게요",
                  preferredStyle: .actionSheet)
    }
}

// MARK: - UITableView Protocol

extension PhraseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        phraseView.emptyStateView.isHidden = (phraseView.tasks.count != 0) ? true : false
        return phraseView.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkPhraseTableViewCell.identifier, for: indexPath) as? BookmarkPhraseTableViewCell else { return UITableViewCell() }
        cell.setupData(record: phraseView.tasks[indexPath.row])
        cell.phraseImageView.image = FileManagerHelper.shared.loadImageFromDocument(fileName: "\(phraseView.tasks[indexPath.row].objectId).jpg")
        cell.moreButton.addTarget(self, action: #selector(touchupMoreButton(sender:)), for: .touchUpInside)
        cell.moreButton.tag = indexPath.row
        return cell
    }
}

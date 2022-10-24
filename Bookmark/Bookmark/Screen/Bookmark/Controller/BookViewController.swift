//
//  BookViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/21.
//

import UIKit

final class BookViewController: BaseViewController {
    
    // MARK: - Property
    
    let bookView = BookView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = bookView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookView.fetchRealm()
    }
    
    // MARK: - Configure UI & Layout
    
    override func setupDelegate() {
        bookView.configureTableViewDelegate(self, self)
    }
    
    // MARK: - @objc
    
    @objc func touchupMoreButton(sender: UIButton) {
        let share = UIAlertAction(title: "공유하고 싶어요", style: .default) { _ in
            guard let cell = self.bookView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))
                    as? BookmarkBookTableViewCell else { return }
            
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
        let delete = UIAlertAction(title: "지우고 싶어요", style: .default) { _ in
            self.bookView.repository.deleteRecord(record: self.bookView.tasks[sender.tag],
                                                    store: self.bookView.tasks[sender.tag].store ?? Store())
            NotificationCenter.default.post(name: NSNotification.Name("countBook"), object: nil)
            self.bookView.fetchRealm()
        }
        showAlert(title: "꽂은 책갈피를",
                  message: nil,
                  actions: [share, delete],
                  cancelTitle: "그대로 둘게요",
                  preferredStyle: .actionSheet)
    }
}

// MARK: - UITableView Protocol

extension BookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookView.emptyStateView.isHidden = (bookView.tasks.count != 0) ? true : false
        return bookView.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkBookTableViewCell.identifier, for: indexPath) as? BookmarkBookTableViewCell
        else { return UITableViewCell() }
        cell.moreButton.addTarget(self, action: #selector(touchupMoreButton(sender:)), for: .touchUpInside)
        cell.moreButton.tag = indexPath.row
        cell.setupData(record: bookView.tasks[indexPath.item])
        cell.bookImageView.image = FileManagerHelper.shared.loadImageFromDocument(fileName: "\(bookView.tasks[indexPath.row].objectId).jpg")
        return cell
    }
}

//
//  PhraseViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/21.
//

import UIKit

final class PhraseViewController: BaseViewController {
    
    // MARK: - Property
    
    private let phraseView = PhraseView()
    
    private let phraseList = [Phrase(image: Icon.Image.gallery, store: "초소산점", book: "나미아백화점"),
                      Phrase(image: Icon.Image.gallery, store: "교보문고 광화문점", book: "어서오세요 휴남동 서점입니다."),
                      Phrase(image: Icon.Image.gallery, store: "yes24 강서점", book: "아무 것도 하고 싶지 않습니다."),
                      Phrase(image: Icon.Image.gallery, store: "홍익문고", book: "어서오세요 휴남동 서점입니다.")]
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = phraseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function, "나와라")
        phraseView.fetchRealm()
    }
    
    // MARK: - Configure UI & Layout
    
    override func setupDelegate() {
        phraseView.configureTableViewDelegate(self, self)
    }
}

// MARK: - UITableView Protocol

extension PhraseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        phraseView.emptyStateView.isHidden = (phraseList.count != 0) ? true : false
        return phraseView.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkPhraseTableViewCell.identifier, for: indexPath) as? BookmarkPhraseTableViewCell else { return UITableViewCell() }
        cell.setupData(data: phraseView.tasks[indexPath.row])
        // MARK: - TODO 이미지 데이터 반영
        return cell
    }
    
    // leading -> 수정
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            let viewController = WriteViewController()
            self.transition(viewController, .present) { _ in
                viewController.writeView.setupWriteViewState(Icon.Button.close, .sentence)
                viewController.fromWhatView = .bookmark
                viewController.viewType = .edit
                viewController.writeView.completeButton.setTitle("수정", for: .normal)
            }
        }
        edit.backgroundColor = Color.green100
        edit.title = "수정"
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            phraseView.repository.deleteRecord(item: phraseView.tasks[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

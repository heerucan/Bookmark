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
        configureUI()
        configureLayout()
        configureDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phraseView.fetchRealm()
    }
    
    // MARK: - Configure UI & Layout

    private func configureDelegate() {
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

//            self.repository.updateFavorite(item: self.tasks[indexPath.row])
            
            /* 여기서도 didSet으로 프로퍼티가 변경 시마다 reload해주기 때문에 아래 코드는 주석처리해도 된다.
             
             하나의 record에서 하나만 reload하니까 상대적으로 효율적임 -> 이게 좀 더 스무스하긴 하네.. 내 취향이네..
            // self.homeTableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            
             데이터가 변경됐으니 다시 realm에서 데이터를 가지고 오기 => didSet 일관적 형태로 갱신
            // self.fetchRealmData() */
        }
        
        // realm 데이터 기준으로 이미지 변경
//        let image = tasks[indexPath.row].edit ? Icon.Image.edit : "heart"
//        edit.image = UIImage(systemName: image)
//        edit.backgroundColor = Color.green100
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

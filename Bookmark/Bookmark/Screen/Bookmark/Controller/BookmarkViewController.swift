//
//  BookmarkViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

final class BookmarkViewController: BaseViewController {
    
    // MARK: - Realm
    
    let repository = BookmarkRepository.shared
        
    // MARK: - Property
    
    var dataViewControllers: [UIViewController] {
        [phraseViewController, bookViewController]
    }
    
    lazy var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers([dataViewControllers[self.currentPage]],
                                                       direction: direction,
                                                       animated: true)
        }
    }
    
    private let phraseViewController = PhraseViewController()
    private let bookViewController = BookViewController()
    
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal)
    
    private let titleLabel = UILabel().then {
        $0.text = "Bookmark".localized
        $0.font = Font.title3.font
        $0.textColor = Color.black100
    }
    
    private let totalCountLabel = UILabel().then {
        $0.font = Font.title3.font
        $0.textColor = Color.main
    }
    
    let segementedControl = BookmarkSegmentedControl(items: ["Writing".localized, "Book".localized]).then {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    }
    
    let writeButton = UIButton().then {
        $0.setImage(Icon.Button.write, for: .normal)
        $0.addTarget(self, action: #selector(touchupWriteButton), for: .touchUpInside)
    }
    
    private let lineView = LineView()
    private let lineBottomView = LineView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countBookmark()
    }

    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        changeValue(control: segementedControl)
    }
    
    override func configureLayout() {
        view.addSubviews([titleLabel,
                          totalCountLabel,
                          segementedControl,
                          writeButton,
                          lineView,
                          lineBottomView])
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(titleLabel.snp.trailing).offset(3)
        }
        
        writeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.height.equalTo(44)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        segementedControl.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(58)
        }
        
        lineBottomView.snp.makeConstraints { make in
            make.top.equalTo(segementedControl.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(lineBottomView.snp.bottom)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Custom Method
    
    private func countBookmark() {
        totalCountLabel.text = "\(repository.fetchRecord().count)"
    }
    
    // MARK: - @objc

    @objc func receiveCount(_ notification: Notification) {
        countBookmark()
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
        if currentPage == 0 {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(receiveCount(_:)),
                                                   name: NSNotification.Name("countPhrase"),
                                                   object: nil)
        } else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(receiveCount(_:)),
                                                   name: NSNotification.Name("countBook"),
                                                   object: nil)
        }
    }
    
    @objc private func touchupWriteButton() {
        let sentence = UIAlertAction(title: "addWriting".localized, style: .default) { _ in
            let viewController = WriteViewController()
            self.transition(viewController, .present) { _ in
                viewController.writeView.setupWriteViewState(.sentence)
                viewController.fromWhatView = .bookmark
                viewController.bookmarkViewStatus = .write
            }
        }
        let book = UIAlertAction(title: "addBook".localized, style: .default) { _ in
            let viewController = WriteViewController()
            self.transition(viewController, .present) { _ in
                viewController.writeView.setupWriteViewState(.book)
                viewController.fromWhatView = .bookmark
                viewController.bookmarkViewStatus = .write
            }
        }
        showAlert(title: "addActionSheetTitle".localized,
                  actions: [sentence, book])
    }
}

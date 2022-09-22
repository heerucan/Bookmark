//
//  BookmarkViewController.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

final class BookmarkViewController: BaseViewController {

    // MARK: - Property
    
    var dataViewControllers: [UIViewController] {
        [self.phraseViewController,
         self.bookViewController]
    }
    
    lazy var currentPage: Int = 0 {
        didSet {
            print(oldValue, self.currentPage)
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers([dataViewControllers[self.currentPage]],
                                                       direction: direction,
                                                       animated: true)
        }
    }
    
    private let phraseViewController = PhraseViewController()
    private let bookViewController = BookViewController()
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                               navigationOrientation: .horizontal).then {
        $0.setViewControllers([dataViewControllers[0]], direction: .forward, animated: true)
    }
    
    let segementedControl = BookmarkSegmentedControl(items: ["글 한 줄", "책 한 권"]).then {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    }
    
    let writeButton = UIButton().then {
        $0.setImage(Icon.Button.write, for: .normal)
        $0.addTarget(self, action: #selector(touchupWriteButton), for: .touchUpInside)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray400
    }
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        changeValue(control: segementedControl)
    }

    override func configureLayout() {
        view.addSubviews([segementedControl,
                          writeButton,
                          lineView])
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        segementedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(10)
            make.height.equalTo(57)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(segementedControl.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        writeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(segementedControl.snp.centerY)
            make.width.height.equalTo(44)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - @objc
        
    @objc private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
    }
    
    @objc private func touchupWriteButton() {
        let sentence = UIAlertAction(title: "공감 가는 글 한 줄", style: .default) { _ in
            let viewController = WriteViewController()
            self.transition(viewController, .present) { _ in
                viewController.writeView.setupWriteViewState(Icon.Button.close, .sentence)
                viewController.fromWhatView = .bookmark
            }
        }
        let book = UIAlertAction(title: "사고 싶은 책 한 권", style: .default) { _ in
            let viewController = WriteViewController()
            self.transition(viewController, .present) { _ in
                viewController.writeView.setupWriteViewState(Icon.Button.close, .book)
                viewController.fromWhatView = .bookmark
            }
        }
        showAlert(title: "어떤 책갈피를 꽂아두실 건가요?",
                  message: nil,
                  actions: [sentence, book])
    }
}

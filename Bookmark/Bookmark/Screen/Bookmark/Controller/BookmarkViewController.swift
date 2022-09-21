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
        [self.phraseViewController, self.bookViewController]
    }
    
    lazy var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers([dataViewControllers[self.currentPage]],
                                                       direction: direction,
                                                       animated: true)
        }
    }
    
    private let phraseViewController = PhraseViewController().then {
        $0.view.backgroundColor = .red
    }
    
    private let bookViewController = BookViewController().then {
        $0.view.backgroundColor = .blue
    }
    
    let segementedControl = BookmarkSegmentedControl(items: ["글 한 줄", "책 한 권"]).then {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray400
    }
    
    let writeButton = UIButton().then {
        $0.setImage(Icon.Button.write, for: .normal)
        $0.addTarget(self, action: #selector(touchupWriteButton), for: .touchUpInside)
    }
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                               navigationOrientation: .horizontal,
                                                               options: nil).then {
        $0.setViewControllers([dataViewControllers[0]],
                              direction: .forward,
                              animated: true)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
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
    
    private func configureDelegate() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
        
    @objc private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
    }
    
    @objc private func touchupWriteButton() {
        let viewController = WriteViewController()
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
}

// MARK: - UIPageViewController Protocol

extension BookmarkViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        return previousIndex < 0 ? nil : dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        return nextIndex >= dataViewControllers.count ? nil : dataViewControllers[nextIndex]
    }
}

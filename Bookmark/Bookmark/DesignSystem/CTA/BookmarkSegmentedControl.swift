//
//  BookmarkSegmentedControl.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/20.
//

import UIKit

final class BookmarkSegmentedControl: UISegmentedControl {
    
    // MARK: - Initializer
    
    override init(items: [Any]?) {
        super.init(items: items)
        removeBackground()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func removeBackground() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func configureUI() {
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.black100], for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.gray300,
                                     NSAttributedString.Key.font: Font.body3.font], for: .normal)
    }
}

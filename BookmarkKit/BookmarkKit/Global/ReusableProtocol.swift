//
//  ReusableViewProtocol.swift
//  BookmarkKit
//
//  Created by heerucan on 2022/09/12.
//

import UIKit

public protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension UIViewController: ReusableViewProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableViewProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

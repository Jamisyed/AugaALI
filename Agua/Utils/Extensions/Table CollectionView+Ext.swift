//
//  Table CollectionView+Ext.swift
//  Questie
//
//  Created by Neelam Yadav on 01/12/20.
//  Copyright © 2020 KiwiTech. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadableView: AnyObject { }

extension NibLoadableView where Self: UIView {

    static var NibName: String {
        return String(describing: self)
    }

    static func viewFromNib(xibFrame: CGRect? = nil) -> UIView? {
        guard let view = Bundle.main.loadNibNamed(NibName, owner: self, options: nil)?.first as? UIView else {
            return UIView()
        }
        if let frame = xibFrame {
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.frame = frame
        }
        return view
    }
}

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.NibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register(reuseIdentifier: String) {
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}
extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.NibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
extension UITableViewCell {
    static func getEmpltyCell() -> UITableViewCell {
        return UITableViewCell(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 1.0))
    }
}

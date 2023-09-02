//
//  Identifier.swift
//
//  Created by Muneesh Chauhan on 13/05/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
import UIKit

public protocol KTIdentifiable: UIViewController {
    static var identifier: String { get }
}

extension KTIdentifiable where Self: UIViewController {
    public static var identifier: String {
        return String(describing: self)
    }
}
extension UIViewController: KTIdentifiable {}

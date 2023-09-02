//
//  Identifiable.swift
//
//  Created by Muneesh Chauhan on 18/05/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
/// This protocol provide default `identifire` for your Class
/// The default identifire is your class name. You can customize it by providing `identifire` property.
protocol Identifiable: AnyObject {
    static var identifire: String { get }
}
// Default value of `identifire`: Your class name
extension Identifiable where Self: NSObject {
    static var identifire: String { return className }
}

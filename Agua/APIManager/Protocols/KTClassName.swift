//
//  KTClassName.swift
//
//  Created by Muneesh Chauhan on 28/04/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
protocol ClassNameProtocol {
    static var className: String {get}
    var className: String {get}
}
extension ClassNameProtocol {
    public static var className: String {
        return String(describing: self)
    }
    public var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

//
//  AGALayoutConstraints.swift
//  Agua
//
//  Created by Muneesh Chauhan on 14/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
import UIKit
extension NSLayoutConstraint {
/**
 Change multiplier constraint

 - parameter multiplier: CGFloat
 - returns: NSLayoutConstraintfor
*/
func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {

    NSLayoutConstraint.deactivate([self])

    let newConstraint = NSLayoutConstraint(
        item: firstItem as Any,
        attribute: firstAttribute,
        relatedBy: relation,
        toItem: secondItem,
        attribute: secondAttribute,
        multiplier: multiplier,
        constant: constant)

    newConstraint.priority = priority
    newConstraint.shouldBeArchived = self.shouldBeArchived
    newConstraint.identifier = self.identifier

    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
}
}

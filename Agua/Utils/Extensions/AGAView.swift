//
//  BRIView.swift
//
//  Created by Muneesh Chauhan on 28/04/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//
enum BRIVerticalLocation: String {
    case bottom
    case top
    case all
}

import Foundation
import UIKit

extension UIView {
    @IBInspectable
    var isBordered: Bool {
        get { return self.isBordered }
        set {
            _ = newValue
            borderWidth = 0
            borderColor = UIColor.white
        }
    }
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

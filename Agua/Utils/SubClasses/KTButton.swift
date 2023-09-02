import Foundation
import UIKit

class KTButton: UIButton {
    @IBInspectable internal var attributed: Bool = false
    @IBInspectable internal var underlined: Bool = false
    @IBInspectable var isCircular: Bool = false
    @IBInspectable internal var characterSpace: Float = 0.0
    @IBInspectable internal var buttonBorderColor: UIColor? = UIColor.clear
    @IBInspectable internal var buttonBorderWidth: CGFloat = 0
    /// Activity Indicator In Button
    @IBInspectable var indicatorColor: UIColor = .lightGray
    var originalButtonText: String?
    private var buttonTitleColor: UIColor?
    private var buttonColor: UIColor?
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    func setup() {
        self.titleLabel?.font = UIFont(
            name: (self.titleLabel?.font?.fontName)!,
            size: (self.titleLabel?.font.pointSize)!*screenScaleFactor)
        if let borderColor = buttonBorderColor {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = borderColor.cgColor
        }
        self.isExclusiveTouch = true
        if isCircular {
            layer.cornerRadius = bounds.height/2
        }
    }
    override func setTitle(_ title: String?, for forState: UIControl.State) {
        if !attributed {
            super.setTitle(title, for: forState)
        }
    }
    func centerButtonAndImageWithSpacing(_ spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: spacing)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 10, right: spacing)
    }
}

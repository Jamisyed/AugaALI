import Foundation
import UIKit

@IBDesignable
class KTTextField: UITextField {
    @IBInspectable internal var isPlaceholderHighlighted: Bool = false
    @IBInspectable internal var attributed: Bool = false {
        didSet {
            if attributed {
                self.attributedPlaceholder = NSAttributedString(
                    string: self.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderColor])
            }
        }
    }
    @IBInspectable internal var underlined: Bool = false
    @IBInspectable internal var selectedTitleEnabled: Bool = true
    @IBInspectable internal var isCenterAlignment: Bool = false
    @IBInspectable internal var characterSpace: Float = 0.0
    @IBInspectable internal var padding: CGFloat = 10.0 {
        didSet {
            let iconContainerViewLeft: UIView = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: padding,
                height: self.frame.size.height))
            leftView = iconContainerViewLeft
            leftViewMode = .always
            let iconContainerViewRight: UIView = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: padding,
                height: self.frame.size.height))
            rightView = iconContainerViewRight
            rightViewMode = .always
        }
    }
    @IBInspectable internal var isProfileTextField: Bool = false
    @IBInspectable
    public var showClearButton: Bool = false {
        didSet {
            if showClearButton {
                btnObj?.isHidden = showClearButton
            }
        }
    }
    var btnObj: UIButton?
    var placeHolderPadding = UIEdgeInsets(
        top: 0,
        left: CGFloat(AGANumericConstants.ten),
        bottom: 0,
        right: CGFloat(AGANumericConstants.ten))
    var textFieldID = ""
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    func setup() {
        self.font = UIFont(name: (self.font?.fontName)!, size: (self.font!.pointSize)*screenScaleFactor)
        self.addTarget(self, action: #selector(self.showHideClearButton), for: .editingChanged)
        self.addTarget(self, action: #selector(self.showHideClearButton), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.hideClearButton), for: .editingDidEnd)
    }
    @objc func showHideClearButton() {
        if self.text?.trimmingCharacters(in: .whitespaces) != "" {
            self.btnObj?.isHidden = false
        } else {
            self.btnObj?.isHidden = true
        }
    }
    @objc func hideClearButton() {
        self.btnObj?.isHidden = true
    }
    @objc func clearTextField() {
        if self.text?.trimmingCharacters(in: .whitespaces) != "" {
            self.text = ""
            btnObj?.isHidden = true
        }
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

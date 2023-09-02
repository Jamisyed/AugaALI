import Foundation
import UIKit

@IBDesignable
class KTLabel: UILabel {
    @IBInspectable internal var attributed: Bool = true
    @IBInspectable internal var underlined: Bool = false
    @IBInspectable internal var characterSpace: Float = 0.0
    @IBInspectable internal var lineSpace: CGFloat = 0.0
    override  open func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    func setup() {
        self.font  =  UIFont(name: (self.font?.fontName)!, size: (self.font.pointSize)*screenScaleFactor)
    }
}
extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    func setLineSpacing(spacing: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineSpacing = spacing
            attributeString.addAttribute(
                NSAttributedString.Key.paragraphStyle,
                value: style, range: NSRange(location: 0, length: text.count))
            self.attributedText = attributeString
        }
    }
}

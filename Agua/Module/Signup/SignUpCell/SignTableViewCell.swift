//
//  SignTableViewCell.swift
//  Agua
//
//  Created by Muneesh Kumar on 23/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let xVal = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x
        let yVal = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        let textContainerOffset = CGPoint(x: xVal, y: yVal)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        var indexOfCharacter = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
               in: textContainer,
               fractionOfDistanceBetweenInsertionPoints: nil)
        indexOfCharacter += 4
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
enum SignUpTextFieldType {
    case userName(validationError: String)
    case email(validationError: String)
    case mobile(validationError: String)
}
protocol SignUpProtocol: AnyObject {
    func crossButtonTapped()
    func textFieldBeginEditiong(textFieldType: SignUpTextFieldType)
    func textFieldChangeEditing(textFieldType: SignUpTextFieldType, text: String)
    func checkMarkAction(isSelected: Bool)
    func validationData(tuple: (SignUpTextFieldType, SignUpTextFieldType))
    func termsOfServiceClicked()
}

import UIKit

class SignTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet weak var termsOfServiceLbl: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var mobileErrorLbl: KTLabel!
    @IBOutlet weak var mobileTxtField: KTTextField!
    @IBOutlet weak var emailErrorLbl: KTLabel!
    @IBOutlet weak var emailTxtField: KTTextField!
    weak var delegate: SignUpProtocol?
    var viewModel = SignUpTableCellViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        let attributedString = NSMutableAttributedString(
            string: AGAStringConstants.ListenVoice.kTermsOfServive,
            attributes: [.font: UIFont(
                name: AGAFont.Lexend.kRegular,
                size: CGFloat(AGANumericConstants.k12)*screenScaleFactor)!,
          .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
          .kern: 0.23
        ])
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 18, length: 16))
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.greenColor, range: NSRange(location: 18, length: 16))
        termsOfServiceLbl.attributedText = attributedString
        self.termsOfServiceLbl.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.termsOfServiceLbl.addGestureRecognizer(tapgesture)

        // Initialization code
    }
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
            guard let text = self.termsOfServiceLbl.text else { return }
            let termsAndConditionRange = (text as NSString).range(of: "Terms of Service")
           if gesture.didTapAttributedTextInLabel(label: self.termsOfServiceLbl, inRange: termsAndConditionRange) {
               delegate?.termsOfServiceClicked()
            }
        }
    @IBAction func continueAction(_ sender: UIButton) {
        let validationData = viewModel.checkValidation()
        delegate?.validationData(tuple: validationData)
    }
    @IBAction func tickAction(_ sender: UIButton) {
        let tickMarkState = viewModel.isCheckBoxSelected
        viewModel.isCheckBoxSelected = !tickMarkState
        let image = viewModel.isCheckBoxSelected ? #imageLiteral(resourceName: "checkedTickMark") : #imageLiteral(resourceName: "unTickIcon.pdf")
        tickButton.setImage(image, for: .normal)
        delegate?.checkMarkAction(isSelected: viewModel.isCheckBoxSelected)
    }
    @IBAction func crossAction(_ sender: UIButton) {
        delegate?.crossButtonTapped()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(isTickMarkChecked: Bool, emailErrorMessage: String, mobileErrorMessage: String) {
        viewModel.isCheckBoxSelected = isTickMarkChecked
        let image = isTickMarkChecked ? #imageLiteral(resourceName: "checkedTickMark") : #imageLiteral(resourceName: "unTickIcon.pdf")
        tickButton.setImage(image, for: .normal)
        emailErrorLbl.text = emailErrorMessage
        mobileErrorLbl.text = mobileErrorMessage
    }
}

// MARK: - UITextField delegate methods

extension SignTableViewCell: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == " " { return false }
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if textField == emailTxtField {
            if updatedString?.count ?? 0 > AGANumericConstants.sixtyFour { return false}
            viewModel.email = updatedString ?? ""
            emailErrorLbl.text = ""
            delegate?.textFieldChangeEditing(textFieldType: .email(validationError: ""), text: viewModel.email)
        }
        if textField == mobileTxtField {
            if string == "." { return false }
            if updatedString?.count ?? 0 > AGANumericConstants.k12 { return false}
            viewModel.mobile = updatedString ?? ""
            mobileErrorLbl.text = ""
            delegate?.textFieldChangeEditing(textFieldType: .mobile(validationError: ""), text: viewModel.mobile)
        }
        return true
    }
}

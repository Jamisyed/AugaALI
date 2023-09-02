//
//  InputTextFieldCell.swift
//  Agua
//
//  Created by Muneesh Kumar on 14/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//
protocol InputTextFieldProtocol: AnyObject {
    func textFieldBeginEditiong(textFieldType: SignUpTextFieldType)
    func textFieldChangeEditing(textFieldType: SignUpTextFieldType, text: String)
    func changeData(textFieldType: SignUpTextFieldType)
}

import UIKit

class InputTextFieldCell: UITableViewCell, Identifiable {

    @IBOutlet weak var plusOneStackView: UIStackView!
    @IBOutlet weak var errorLbl: KTLabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var textField: KTTextField!
    weak var delegate: InputTextFieldProtocol?
    var textFieldType: SignUpTextFieldType?
    var viewModel = InputTextFieldViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(model: EditProfiledModel) {
        textField.text = model.text
        textField.tintColor = UIColor.greenColor
        self.textFieldType = model.fieldType
        plusOneStackView.isHidden = true
        textField.isUserInteractionEnabled = false
        let fieldType = model.fieldType
        switch fieldType {
        case .userName(let validationError):
            errorLbl.text = validationError
        case .email(let validationError):
            errorLbl.text = validationError
        case .mobile(let validationError):
            errorLbl.text = validationError
        }
        switch model.fieldType {
        case .userName:
            textField.isUserInteractionEnabled = true
            textField.keyboardType = .default
            textField.padding = 25
            // setTextFieldRightPadding(padding: 25)
            changeButton.isHidden = true
            textField.placeholder = "Enter Your Name"
        case .email:
            textField.padding = 25
            textField.keyboardType = .emailAddress
            setTextFieldRightPadding(padding: 75)
            changeButton.isHidden = false
            textField.placeholder = "Email"
        case .mobile:
            plusOneStackView.isHidden = false
            textField.padding = 60
            textField.keyboardType = .decimalPad
            setTextFieldRightPadding(padding: 75)
            changeButton.isHidden = false
            textField.placeholder = "Phone Number"
        }
    }
    func setTextFieldRightPadding(padding: Float) {
        let iconContainerViewRight: UIView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 75,
            height: self.frame.size.height))
        textField.rightView = iconContainerViewRight
        textField.rightViewMode = .always
    }
    @IBAction func changeButtonAction(_ sender: UIButton) {
        if let fieldType = textFieldType {
            delegate?.changeData(textFieldType: fieldType)
        }
    }
}

extension InputTextFieldCell: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderWidth = 0
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderColor = UIColor.greenColor
        textField.borderWidth = 1
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        delegate?.textFieldChangeEditing(textFieldType: .userName(validationError: ""), text: updatedString ?? "")
        switch textFieldType {
        case .email:
            if string == " " { return false }
            if updatedString?.count ?? 0 > AGANumericConstants.sixtyFour { return false}
            viewModel.email = updatedString ?? ""
            errorLbl.text = ""
            delegate?.textFieldChangeEditing(textFieldType: .email(validationError: ""), text: viewModel.email)
        case .userName:
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                    return false
                }
            } catch {
                print("ERROR")
            }
            viewModel.userName = updatedString ?? ""
            errorLbl.text = ""
        case .mobile:
            if string == "." { return false }
            if updatedString?.count ?? 0 > AGANumericConstants.k12 { return false}
            viewModel.mobile = updatedString ?? ""
            errorLbl.text = ""
            delegate?.textFieldChangeEditing(textFieldType: .mobile(validationError: ""), text: viewModel.mobile)
        case .none:
            return true
        }
        return true
    }
}

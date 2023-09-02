//
//  SignUpTableCellViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 23/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import Foundation

class SignUpTableCellViewModel {
    var email = ""
    var mobile = ""
    var isCheckBoxSelected = false
    func checkValidation() -> (SignUpTextFieldType, SignUpTextFieldType) {
        var validationError = (SignUpTextFieldType.email(validationError: ""),
                               SignUpTextFieldType.mobile(validationError: ""))
        if !email.isValidEmail() {
            let emailInvalid = SignUpTextFieldType.email(validationError: AGAStringConstants.Validations.invalidEmail)
            validationError.0 = emailInvalid
        }
        if email.isEmpty {
            let emailEmpty = SignUpTextFieldType.email(validationError: AGAStringConstants.Validations.emptyEmail)
            validationError.0 = emailEmpty
        }
        if !validateMobileNumber(mobile: mobile) {
            let mobileInvalid = SignUpTextFieldType.mobile(
                validationError: AGAStringConstants.Validations.invalidMobile)
            validationError.1 = mobileInvalid
        }
        if mobile.isEmpty {
            let mobileEmpty = SignUpTextFieldType.mobile(validationError: AGAStringConstants.Validations.emptyMobile)
            validationError.1 = mobileEmpty
        }
        return validationError
    }
    private func validateMobileNumber(mobile: String) -> Bool {
        if mobile.count == AGANumericConstants.ten || mobile.count == AGANumericConstants.k12 { return true }
        return false
    }
}

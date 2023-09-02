//
//  AGAString.swift
//  Agua
//
//  Created by Muneesh Kumar on 24/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import Foundation
extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func validateIndianNumber() -> Bool {
        let phoneR = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneR)
        let result = phoneTest.evaluate(with: self)
        return result
    }
    func validateUSANumber() -> Bool {
        let phoneR = "^[6-9]\\d{11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneR)
        let result = phoneTest.evaluate(with: self)
        return result
    }

}

//
//  SignUpTableCellViewModel.swift
//  AguaTests
//
//  Created by Muneesh Kumar on 06/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import XCTest
@testable import Agua

class SignUpTableCellViewModelTest: XCTestCase {
    let viewModel = SignUpTableCellViewModel()
    var email = ""
    var mobile = ""
    func testEmailEmptyValidation() {
        email = ""
        let validationTuple = viewModel.checkValidation()
        switch validationTuple.0 {
        case .email(let emailError):
            XCTAssertNotEqual(emailError, "")
        default: break
        }
    }
    func testEmailValidValidation() {
        email = "wrongEmail"
        let validationTuple = viewModel.checkValidation()
        switch validationTuple.0 {
        case .email(let emailError):
            XCTAssertNotEqual(emailError, "")
        default: break
        }
    }
    func testMobileNumberMinDigit() {
        mobile = "99999"
        let validationTuple = viewModel.checkValidation()
        switch validationTuple.1 {
        case .mobile(let mobError):
            XCTAssertNotEqual(mobError, "")
        default: break
        }
    }
    func testMobileNumberMaxDigit() {
        mobile = "9999999999999"
        let validationTuple = viewModel.checkValidation()
        switch validationTuple.1 {
        case .mobile(let mobError):
            XCTAssertNotEqual(mobError, "")
        default: break
        }
    }
    func testMobileNumberEmpty() {
        mobile = ""
        let validationTuple = viewModel.checkValidation()
        switch validationTuple.1 {
        case .mobile(let mobError):
            XCTAssertNotEqual(mobError, "")
        default: break
        }
    }
}

//
//  LoginViewModelTest.swift
//  AguaTests
//
//  Created by Muneesh Kumar on 04/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import XCTest
@testable import Agua
class LoginViewModelTest: XCTestCase {
    let loginVM = AGALoginViewModel()
    var mobile = ""
    override class func setUp() {
        super.setUp()
    }
    func testMobileNumberMinDigit() {
        mobile = "99999"
        let validationError = loginVM.checkValidation()
        XCTAssertNotEqual(validationError, "")
    }
    func testMobileNumberMaxDigit() {
        mobile = "9999999999999"
        let validationError = loginVM.checkValidation()
        XCTAssertNotEqual(validationError, "")
    }
    func testMobileNumberEmpty() {
        mobile = ""
        let validationError = loginVM.checkValidation()
        XCTAssertNotEqual(validationError, "")
    }
}

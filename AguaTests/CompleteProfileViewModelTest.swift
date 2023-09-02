//
//  CompleteProfileViewModelTest.swift
//  AguaTests
//
//  Created by Muneesh Kumar on 06/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import XCTest
@testable import Agua

class CompleteProfileViewModelTest: XCTestCase {
var  viewModel = CompleteProfileViewModel()
    var userName = ""
    var image: UIImage?
    func testVerifyForValidUserName() {
        userName = ""
        let status = viewModel.validateIfUserNameIsEmpty()
        XCTAssert(status)
    }
    func testVerifyUserImage() {
        image = nil
        let status = viewModel.validateIfProfilePicIsEmpty()
        XCTAssert(status)
    }
}

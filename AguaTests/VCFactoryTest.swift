//
//  VCFactoryTest.swift
//  AguaTests
//
//  Created by Muneesh Kumar on 16/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import XCTest
@testable import Agua

class VCFactoryTest: XCTestCase {
    func testWelcomeVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let welcomeVC = vcFactory.welcomeVC()
        XCTAssertNotNil(welcomeVC)
    }
    func testSignUpVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let signupVC = vcFactory.instatiateSignUp()
        XCTAssertNotNil(signupVC)
    }
    func testSignInVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let signInVC = vcFactory.instatiateSignIn()
        XCTAssertNotNil(signInVC)
    }
    func testOTPVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let otpVC = vcFactory.instatiateOTP()
        XCTAssertNotNil(otpVC)
    }
    func completeProfileVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let completeProfileVC = vcFactory.completeProfileVC()
        XCTAssertNotNil(completeProfileVC)
    }
    func webViewVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let webViewVC = vcFactory.webKitVC()
        XCTAssertNotNil(webViewVC)
    }
    func profileVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let profileVC = vcFactory.profileVC()
        XCTAssertNotNil(profileVC)
    }
    func bookmarkListVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let bookmarkListVC = vcFactory.bookmarkListVC()
        XCTAssertNotNil(bookmarkListVC)
    }
    func testHomeVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let homeVC = vcFactory.instatiateHomeVC()
        XCTAssertNotNil(homeVC)
    }
    func testMusicInfoVC() {
        let vcFactory: KTVCFactoryProtocol = KTVCFactory()
        let musicInfoVC = vcFactory.instatiateMusicInfo()
        XCTAssertNotNil(musicInfoVC)
    }
}

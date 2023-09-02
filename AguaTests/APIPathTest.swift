//
//  APIRouterTest.swift
//  AguaTests
//
//  Created by Muneesh Kumar on 06/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import XCTest
@testable import Agua

class APIPathTest: XCTestCase {
    func testLoginUrlPath() {
        let apiRouter = APIRouter.login(phone: "", otp: "")
        let urlPath = apiRouter.path
        XCTAssertEqual(urlPath, "account/login/", "")
    }
    func testSignUpUrlPath() {
        let apiRouter = APIRouter.signup(email: "", phone: "", otp: "")
        let urlPath = apiRouter.path
        XCTAssertEqual(urlPath, "account/signup/", "")
    }
    func testCompleteProfilePath() {
        let apiRouter = APIRouter.completeProfile(userName: "")
        let urlPath = apiRouter.path
        XCTAssertEqual(urlPath, "account/userProfile/", "")
    }
    func testSaveSongInfoPath() {
        let apiRouter = APIRouter.saveSongInfo("", "", "", "", "", false)
        let urlPath = apiRouter.path
        XCTAssertEqual(urlPath, "music/Recognize/", "")
    }
    func testAddToBookmarkPath() {
        let apiRouter = APIRouter.addToBookMark(musicId: 0)
        let urlPath = apiRouter.path
        XCTAssertEqual(urlPath, "music/Bookmark/", "")
    }
    func testSongsListPath() {
        let apiRouter = APIRouter.songsList(pageNo: 0)
        let urlPath = apiRouter.path
        XCTAssertEqual(urlPath, "music/Recognize/?page=0", "")
    }
    func testRemoveFromBookmarkPath() {
        let apiRouter = APIRouter.removeBookmark(bookmarkId: 0)
        let urlPath = apiRouter.path
        XCTAssertEqual(urlPath, "music/Bookmark/0/", "")
    }
    func testGetBookmarkSongsList() {
        let apiRouter = APIRouter.getBookmarkSongsList(pageNo: 0)
        let urlPath = apiRouter.path
        XCTAssertEqual(urlPath, "music/Bookmark/?page=0", "")
    }
}

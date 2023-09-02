//
//  ConnectivityUtilsTests.swift
//  AguaTests
//
//  Created by Muneesh Kumar on 06/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import XCTest
@testable import Agua
class ConnectivityUtilsTests: XCTestCase {

    func testVerifyIfNetworkConnected() {
        let networkStatus = ConnectivityUtils.isConnectedToNetwork()
        XCTAssert(networkStatus)
    }
}

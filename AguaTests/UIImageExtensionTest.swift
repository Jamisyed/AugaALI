//
//  UIImageExtensionTest.swift
//  AguaTests
//
//  Created by Muneesh Kumar on 16/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import XCTest
@testable import Agua
class UIImageExtensionTest: XCTestCase {

    func testTestBulrImage() {
        let image = #imageLiteral(resourceName: "Img-headphones-blur.png").blurImage()
        XCTAssertNotNil(image)
    }
}

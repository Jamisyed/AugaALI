//
//  AGAConstants.swift
//  Agua
//
//  Created by Muneesh Chauhan on 12/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
import UIKit
let screenScaleFactor: CGFloat =  DeviceType.isiPad ? 1 : UIScreen.main.bounds.size.width / 375.0
struct DeviceType {
    static let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}

struct URLConstant {
    static let tersAndConditon = "https://api.agua.technology/term_and_condition/"
    static let privacyPolicy = "https://api.agua.technology/Privacy_policy/"
    static let howToUse = "https://api.agua.technology/How_to_use_ios/"
}

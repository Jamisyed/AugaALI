//
//  EnvironmentVariable.swift
//  Agua
//
//  Created by Muneesh Kumar on 18/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation

class EnvironmentVariable {
    private enum InfoPlistKey: String {
        case baseUrl = "BASE_URL"
    }
    static let shared = EnvironmentVariable()
    private let infoPlist: [String: Any]
    var apiBaseUrl: String {
        return infoPlist[InfoPlistKey.baseUrl.rawValue] as? String ?? ""
    }
    private init() {
        guard let infoPlistFile = Bundle.main.infoDictionary else {
            fatalError("Where is the info.plist file?")
        }
        infoPlist = infoPlistFile
    }
}

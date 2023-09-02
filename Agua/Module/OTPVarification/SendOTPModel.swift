//
//  SendOTPModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 08/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
// MARK: - SendOTPModel
struct SendOTPModel: Codable {
    let detail: String?
    let data: Phone?
    let error: Bool?
}

// MARK: - DataClass
struct Phone: Codable {
    let id: Int?
    let phone: String?
}

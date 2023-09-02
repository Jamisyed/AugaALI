//
//  UserModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 29/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let detail: String?
    let data: UserData?
    let error: Bool?
}

// MARK: - DataClass
struct UserData: Codable {
    let email, phone: String?
    let userId: Int?
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case email, phone
    }
}

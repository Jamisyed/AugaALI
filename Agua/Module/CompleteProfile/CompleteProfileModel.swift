//
//  CompleteProfileModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 01/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation

// MARK: - CompleteProfileModel
struct CompleteProfileModel: Codable {
    let detail: String?
    let data: DataClass?
    let error: Bool?
}

// MARK: - DataClass
struct DataClass: Codable {
    let userId: Int?
    let userName: String?
    let profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case userName = "user_name"
        case profilePicture = "profile"
    }
}

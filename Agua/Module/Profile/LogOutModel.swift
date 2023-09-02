//
//  LogOutModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 02/03/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation

// MARK: - LogOutModel
struct LogOutModel: Codable {
    let detail: String?
    let error: Bool?
}

// MARK: - DataClass
struct LogOut: Codable {
    let message: String?
}

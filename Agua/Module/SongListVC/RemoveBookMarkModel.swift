//
//  RemoveBookMarkModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 11/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
// MARK: - RemoveBookMarkModel
struct RemoveBookMarkModel: Codable {
    let detail: String?
    let data: RemoveBookmark?
    let error: Bool?
}

// MARK: - DataClass
struct RemoveBookmark: Codable {
}

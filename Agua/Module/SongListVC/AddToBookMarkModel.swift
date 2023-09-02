//
//  AddToBookMarkModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 11/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation

// MARK: - AddToBookMarkModel
struct AddToBookMarkModel: Codable {
    let detail: String?
    let data: BookMarkData?
    let error: Bool?
}

// MARK: - DataClass
struct BookMarkData: Codable {
    let bookmarkId: Int?
    enum CodingKeys: String, CodingKey {
        case bookmarkId = "id"
    }
}

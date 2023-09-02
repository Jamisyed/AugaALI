//
//  SaveProductModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 21/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
// MARK: - SaveProductModel
struct SaveProductModel: Codable {
    let detail: String?
    let data: ProductDetail?
    let error: Bool?
}

// MARK: - DataClass
struct ProductDetail: Codable {
    let productId: Int?
    let name: String?
    let brand: Brand?
    let vid, acrid: String?
    let bookmark: Bookmark?
    enum CodingKeys: String, CodingKey {
        case productId = "id"
        case name, brand, vid, acrid, bookmark
    }
}

// MARK: - Brand
struct Brand: Codable {
    let brandId: Int?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case brandId = "id"
        case name
    }
}

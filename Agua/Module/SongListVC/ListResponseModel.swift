//
//  SongResponseModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 08/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation

// MARK: - SongsResponseModel
struct ListResponseModel: Codable {
    let detail: String?
    let data: SongInfo?
    let error: Bool?
}

// MARK: - DataClass
struct SongInfo: Codable {
    let meta: Meta?
    let result: [Result]?
}

// MARK: - Meta
struct Meta: Codable {
    let currentPage, total, lastPage, perPage: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case total
        case lastPage = "last_page"
        case perPage = "per_page"
    }
}

// MARK: - Result
struct Result: Codable {
    let songId: Int?
    let title: String?
    let artists: [Artist]?
    let product: [Product]?
    var bookmark: Bookmark?
    let vid, acrid, trackID: String?
    enum CodingKeys: String, CodingKey {
        case songId = "id"
        case product
        case title, artists, bookmark, vid, acrid, trackID
    }
}
// MARK: - Product
struct Product: Codable {
    let productId: Int?
    let name: String?
    let brand: Brand?
    let vid, acrid: String?
    enum CodingKeys: String, CodingKey {
        case productId = "id"
        case name, brand, vid, acrid
    }
}
// MARK: - Artist
struct Artist: Codable {
    let artistId: Int?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case artistId = "id"
        case name
    }
}

// MARK: - Bookmark
struct Bookmark: Codable {
    var isSubscribed: Bool?
    var bookmarkId: Int?
    enum CodingKeys: String, CodingKey {
        case bookmarkId = "id"
        case isSubscribed = "is_subscribed"
    }
}

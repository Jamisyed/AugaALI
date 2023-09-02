//
//  SaveSpotifyToken.swift
//  Agua
//
//  Created by Muneesh Kumar on 09/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
// MARK: - SaveSpotifyTokenModel
struct SaveSpotifyTokenModel: Codable {
    let detail: String?
    let data: SpotifyData?
    let error: Bool?
}

// MARK: - DataClass
struct SpotifyData: Codable {
    let id: Int?
    let spotifyToken: String?

    enum CodingKeys: String, CodingKey {
        case id
        case spotifyToken = "spotify_token"
    }
}

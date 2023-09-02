//
//  LoginModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 31/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import Foundation
// MARK: - LoginModel
struct LoginModel: Codable {
    let detail: String?
    let data: LoginData?
    let error: Bool?
}
struct LoginData: Codable {
    let userId: Int?
    let email: String?
    let token: Token?
    let spotifyToken: SpotifyToken?
    let profilePicture, userName: String?
    let isActive: Bool?
    let phone: String?
    let detail: String?
    let error: Bool?

    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case spotifyToken = "spotify_token"
        case email, token, detail, error
        case profilePicture = "profile_picture"
        case userName = "user_name"
        case isActive = "is_active"
        case phone
    }
}

// MARK: - SpotifyToken
struct SpotifyToken: Codable {
    let spotifyToken: String?

    enum CodingKeys: String, CodingKey {
        case spotifyToken = "spotify_token"
    }
}
// MARK: - Token
struct Token: Codable {
    let accessToken: String?
    let expiresIn: Int?
    let refreshToken, scope: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
    }
}

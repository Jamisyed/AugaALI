//
//  AuthResponseModel.swift
//  MyNewSpotifyDemo
//
//  Created by Muneesh Kumar on 31/01/22.
//

// MARK: - AuthResponseModel
struct AuthResponseModel: Codable {
    let accessToken: String?
    let expiresIn: Int?
    let refreshToken, scope, tokenType: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case tokenType = "token_type"
    }
}

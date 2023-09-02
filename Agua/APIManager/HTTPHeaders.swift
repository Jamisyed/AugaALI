//
//  HTTPHeaders.swift
//  FinaBet

import Foundation
import Alamofire

extension APIRouter {
    var header: [String: String]? {
        var headerParam: [String: String] = [:]
        switch self {
        case .getSpotifyPlayList, .getSpotifyUserId, .createPlayList, .addSonginPlayList:
            if let token = AuthManager.shared.accessToken, !token.isEmpty {
                headerParam[HTTPHeaderField.authentication.rawValue] = "Bearer \(token)"
            }
        default:
            headerParam[HTTPHeaderField.acceptType.rawValue] = ContentType.json.rawValue
            headerParam[HTTPHeaderField.contentType.rawValue] = ContentType.json.rawValue
            if let token = AppUserDefault.getStringValue(key: .userToken), !token.isEmpty {
                headerParam[HTTPHeaderField.authentication.rawValue] = "bearer \(token)"
            }
        }
        return headerParam
    }
}
enum ParameterKey: String {
    case profilePicture = "profile_picture"
    case none
}

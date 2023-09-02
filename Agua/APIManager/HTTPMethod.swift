//
//  APIRouter+HTTPMethod.swift
//  FinaBet

import Foundation
import Alamofire

extension APIRouter {
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .songsList, .getBookmarkSongsList, .getProductsList, .getSpotifyPlayList, .getSpotifyUserId, .getUserProfile, .logout: return .get
        case .removeBookmark, .deleteAccount: return .delete
        default:
            return .post
        }
    }
}

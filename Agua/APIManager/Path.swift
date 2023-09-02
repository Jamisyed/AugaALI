//
//  Path.swift
//  FinaBet

import Foundation
extension APIRouter {
    // MARK: - Path
    var path: String {
        switch self {
        case .login:
            return "account/login/"
        case .signup:
            return "account/signup/"
        case .getUserProfile:
            return "account/userProfile/"
        case .logout:
            return "account/logout/"
        case .deleteAccount:
            return "account/delete_user/"
        case .changeEmail:
            return "account/userProfile/ChangeEmail/"
        case .sendOTP:
            return "account/login/SendOTP/"
        case .completeProfile:
            return "account/userProfile/"
        case .changeMobile:
            return "account/userProfile/ChangePhone/"
        case .saveSongInfo:
            return "music/Recognize/"
        case .saveProductData:
            return "products/product/"
        case .songsList(let pageNo):
            return "music/Recognize/?page=\(pageNo)"
        case .getProductsList(let pageNo):
            return "products/bookmark/?page=\(pageNo)"
        case .addToBookMark:
            return "music/Bookmark/"
        case .removeBookmark(let bookmarkId):
            return "music/Bookmark/\(bookmarkId)/"
        case .getBookmarkSongsList(let pageNo):
            return "music/Bookmark/?page=\(pageNo)"
        case .getSpotifyPlayList:
            return "me/playlists"
        case .addSonginPlayList(let playListId, _):
            return "playlists/\(playListId)/tracks"
        case .createPlayList(let userId):
            return "users/\(userId)/playlists"
        case .getSpotifyUserId:
            return "me"
        case .saveSpotifyToken:
            return "music/Token/"
        case .none:
            return ""
        }
    }
}

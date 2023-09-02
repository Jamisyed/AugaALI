//
//  Parameters.swift
// FinaBet

import Foundation
import Alamofire
// MARK: - Parameters
extension APIRouter {
    var parameters: Parameters? {
        switch self {
        case .login(let mobile, let otp):
            let countryCode = AGAStringConstants.countryCode
            if otp.isEmpty {
                return ["phone": countryCode + mobile]
            } else {
                return ["phone": countryCode + mobile, "otp": otp]
            }
        case .changeEmail(let email):
            return ["email": email]
        case .signup(let email, let mobile, let otp):
            let countryCode = AGAStringConstants.countryCode
            if otp.isEmpty {
                return ["email": email, "phone": countryCode + mobile]
            } else {
                return ["email": email, "phone": countryCode + mobile, "otp": otp]
            }
        case .sendOTP(let mobile):
            let countryCode = AGAStringConstants.countryCode
            return ["phone": countryCode + mobile]
        case .completeProfile(let userName, let isProfilePicRemove):
            return ["user_name": userName, "is_profile_picture_remove": isProfilePicRemove]
        case .changeMobile(let mobile, otp: let otp):
            let countryCode = AGAStringConstants.countryCode
            if otp.isEmpty {
                return ["phone": countryCode + mobile]
            } else {
                return ["phone": countryCode + mobile, "otp": otp]
            }
        case .saveSongInfo(let trackId, let artistName, let titleName, let vId, let lavel, let bookmarkStatus):
            print(lavel)
            var inputParams = [String: Any]()
            inputParams["title"] = titleName
            inputParams["vid"] = vId
            inputParams["arcid"] = vId
            inputParams["trackID"] = trackId
            inputParams["artists"] = [["name": artistName]]
            inputParams["is_subscribed"] = bookmarkStatus
            return inputParams
        case .saveProductData(let productName, let brandName, let vId, let acrId):
            var inputParams = [String: Any]()
            inputParams["name"] = productName
            inputParams["brand"] = ["name": brandName]
            inputParams["vid"] = vId
            inputParams["acrid"] = acrId
            inputParams["is_subscribed"] = true
            return inputParams
        case .addToBookMark(let musicId):
            return ["Music_id": musicId]
        case .addSonginPlayList(_, let uri):
            var inputParams = [String: Any]()
            inputParams["uris"] = "spotify:track:\(uri)"
            inputParams["position"] = 0
            return inputParams
        case .createPlayList:
            var inputParams = [String: Any]()
            inputParams["name"] = "My Agua Tracks"
            inputParams["description"] = "Agua Tracks"
            inputParams["public"] = true
            return inputParams
        case .saveSpotifyToken:
            let spotifyToken = AuthManager.shared.accessToken ?? ""
            return ["spotify_token": spotifyToken]
        default: return nil
        }
    }
}

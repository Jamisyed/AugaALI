//
//  APIRouter.swift
//  Networking
//
//  Created by Nageshwar Agrahari on 23/08/2021.
//  Copyright © 2021 kiwiTech Me. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    case login(phone: String, otp: String)
    case signup(email: String, phone: String, otp: String)
    case sendOTP(mobile: String)
    case songsList(pageNo: Int)
    case getUserProfile
    case logout
    case deleteAccount
    case changeEmail(email: String)
    case completeProfile(userName: String, isPicRemove: Bool)
    case changeMobile(mobile: String, otp: String)
    case saveSongInfo(_ trackID: String,
                       _ artistName: String,
                       _ titleName: String,
                       _ vid: String?,
                       _ label: String,
                      _ bookmarkStatus: Bool)
    case addToBookMark(musicId: Int)
    case removeBookmark(bookmarkId: Int)
    case getBookmarkSongsList(pageNo: Int)
    case getProductsList(pageNo: Int)
    case saveProductData(productName: String, brandName: String, vId: String, acrId: String)
    case getSpotifyPlayList
    case createPlayList(userId: String)
    case addSonginPlayList(playListId: String, uri: String)
    case saveSpotifyToken
    case getSpotifyUserId
    case none
    public var baseURL: String {
        switch self {
        case .getSpotifyPlayList, .getSpotifyUserId, .createPlayList, .addSonginPlayList:
            return "https://api.spotify.com/v1/"
        default:
            return "https://api.agua.technology/" // Production Url
            //"https://api.agua.technology/" // Production Url
            //"https://agua-stage.kiwi-internal.com/" // stage
        }
    }
    // MARK: - create an URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        let urlWithPath = url.appendingPathComponent(path).absoluteString.removingPercentEncoding ?? ""
        var urlRequest = URLRequest(url: URL(string: urlWithPath)!)
        urlRequest.httpMethod = method.rawValue
        if let queryParam = header {
            for (key, value) in queryParam {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        debugPrint("url===+", urlRequest)
        debugPrint("header===+", header ?? [])

        // Parameters
        guard let parameters = parameters else {
            return urlRequest
        }
        debugPrint("Param", parameters)
        return  try encoding.encode(urlRequest, with: parameters)
    }
}

//
//  AuthManager.swift
//  MyNewSpotifyDemo
//
//  Created by Muneesh Kumar on 30/01/22.
//

import Foundation
  
final class AuthManager {
    static let shared = AuthManager()
    struct Constants {
        static let clientID = "dfe20457728e4cc4a53f2e8f5c13e366" // cliend account key
        // "8f368904cd3943a8ae58e625d3ccb8bd" // same as android
        // "b5083a6a2ede4059be8181f96603ca43"
        static let clientSecret = "7c6340ca3421416daca0c8d5798b6db7" // Client Account key
        // "0b91194e086645dfa1bfcc2f8f52b9f0" // Ritesh Account
        // "31d85d0f370a4c01893b0e9e1d34af99"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.google.com"
        static let scopes = "playlist-modify-private%20playlist-read-collaborative%20user-read-private%20playlist-modify-public"
    }
    private init() {}
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    var isSignIn: Bool {
        return accessToken != nil && accessToken != ""
    }
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    func logout() {
        UserDefaults.standard.removeObject(forKey: "access_token")
    }
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        // API call for app token
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        var component = URLComponents()
        component.queryItems = [
        URLQueryItem(name: "grant_type", value: "authorization_code"),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = component.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, urlResponse, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let model = try JSONDecoder().decode(AuthResponseModel.self, from: data)
                self?.cacheToken(result: model)
                completion(true)
                print("SUCCESS \(model)")
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    public func refreshAccessTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        // refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        var component = URLComponents()
        component.queryItems = [
        URLQueryItem(name: "grant_type", value: "refresh_token"),
        URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = component.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, urlResponse, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let model = try JSONDecoder().decode(AuthResponseModel.self, from: data)
                print("Successfully Refreshed")
                self?.cacheToken(result: model)
                completion(true)
                print("SUCCESS \(model)")
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    private func cacheToken(result: AuthResponseModel) {
        UserDefaults.standard.setValue(result.accessToken, forKey: "access_token")
        if let refreshToken = result.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expiresIn ?? 0)), forKey: "expirationDate")
    }
}

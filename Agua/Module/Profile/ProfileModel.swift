//
//  ProfileModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 02/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
import UIKit

enum ProfileCellType: String {
    case bookmark =  "Bookmarks"
    case paymentMethods = "Payment Methods"
    case connectAccounts = "Connect Accounts"
    case termsAndCondition = "Terms & Conditions"
    case privacy = "Privacy"
    case howToUse = "How to Use"
    case playAdv = "Play Advertisement"
    case logout = "Logout"
    case spotify = "Spotify"
    case amazon = "Amazon"
    case deleteAccount = "Delete Account"
    var image: UIImage {
        switch self {
        case .bookmark: return #imageLiteral(resourceName: "menuBookmark.pdf")
        case .paymentMethods: return #imageLiteral(resourceName: "menuPayment.pdf")
        case .connectAccounts: return #imageLiteral(resourceName: "menuConnectAccount.pdf")
        case .termsAndCondition: return #imageLiteral(resourceName: "menuTermsAndCondition.pdf")
        case .privacy: return #imageLiteral(resourceName: "menuPrivacy.pdf")
        case .howToUse: return #imageLiteral(resourceName: "menuHowToUse.pdf")
        case .logout: return #imageLiteral(resourceName: "menuLogout.pdf")
        case .spotify: return #imageLiteral(resourceName: "spotifyIcon.pdf")
        case .amazon: return #imageLiteral(resourceName: "amazonIcon.pdf")
        case .playAdv: return #imageLiteral(resourceName: "amazonIcon.pdf")
        case .deleteAccount: return UIImage(named: "deleteAcc") ?? #imageLiteral(resourceName: "deleteAcc.pdf")
        }
    }
}
struct ProfileModel {
    let cellType: ProfileCellType
    var connctedState: Bool
}

// MARK: - UserProfile
struct UserProfile: Codable {
    let detail: String?
    var data: UserInfo?
    let error: Bool?
}

// MARK: - DataClass
struct UserInfo: Codable {
    let id: Int?
    var profile: String?
    let userName, phone, email: String?
    let isEmailVarified: Bool?
    let isActive: Bool?
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case profile, phone, email
        case isEmailVarified = "is_email_verified"
        case isActive = "is_active"
    }
}

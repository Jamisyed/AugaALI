//
//  AGAStringConstants.swift
//  Agua
//
//  Created by Muneesh Chauhan on 18/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation

let spotifyBaseURL = "https://api.spotify.com/v1/"
struct AGAStringConstants {
    static let countryCode = "+1"
    struct ListenVoice {
        static let kTermsOfServive = "I agree to Agua’s Terms of Service"
        static let kAgua = "Agua listen"
        static let kAguaText = "Agua"
        static let klisten = "listen"
        static let kTrySaying = "Try saying..."
        static let kWhatSongPlaying = "What song is playing right now"
        static let kWhatSongIsThis = "What song is this"
        static let kWhatProductIsThis = "What product is this"
        static let kListeningYourVoice = "Listening to your \nvoice…"
        static let kListening = "Listening & searching…"
        static let kAccessSpeech = "This app must have access to speech recognition to work."
        static let kUpgradeSetting = "Please consider updating your settings."
        static let kOpenSettings = "Open settings"
        static let kClose = "Close"
        static let kWrongEmailPassword = "please enter valid email and password"
        static let kSorryMessage = "Sorry, but I am having trouble understanding"
        static let kWrongEmail = "Please enter valid email id."
        static let alreadyBookMark = "You already bookmark this song."
        static let passwdEmpty = "Password field can't be blank"
        static let isUserLogin = "is_login."
    }
    struct AlertConst {
        static let deleteAccount = "Delete Account"
        static let delete = "Delete"
        static let cancel = "Cancel"
        static let deleteAccountDesc = "Are you sure you want to delete this account?"
    }
    struct MusicInfo {
        static let bookmarkProduct = "Do you want to bookmark this product"
        static let saveInSpotify = "Songs saved in spotify playlis."
        static let wantTobookMark = "Do you want me to bookmark this song?"
        static let yes = "yes"
        static let noBookMark = "no"
        static let kSharedSong = "Song shared on email and phone"
        static let kBookMarkThisSong = "Bookmark this song"
        static let kUnBookMarkThisSong = "Unbookmark this song"
        static let kBookMark = "Bookmark"
        static let kNoResultFromACR = "No Result from ACR Cloud."
        static let kBookMarkNotification = "Agua Bookmark Notification"
        static let kHiTestuser =  """
Hi Test user,
This is a bookmark of
"""
        static let kYourFriendAtAgua = """
        that you tagged in Agua Utility. Follow this link for more information or to purchase it ...
        Your friends at Agua
"""
        static let username = "<p>Hi Test user, <br />This is a bookmark of <br /> that you requested."
        static let friendAtAgua = " that you purchase it ...<br />friends at Agua</p>"
    }
    struct CommonMessages {
        static let cameraPermission = "Agua app doesn't have access to the resource. Please update your system settings to allow Agua to access."
    }
}
extension AGAStringConstants {
    struct Validations {
        static let emptyEmail = "Email can't be empty."
        static let invalidEmail = "Please enter a valid email."
        static let emptyMobile = "Mobile can't be empty."
        static let invalidMobile = "Please enter a valid mobile number."
        static let selectImage = "Please select user image."
        static let enterName = "Please enter your name."
        static let termsOfSercice = "Please accept Terms of Service."
    }
}

struct OpenSens {
    static let bold = "OpenSans-Bold"
    static let ragular = "OpenSans"
}

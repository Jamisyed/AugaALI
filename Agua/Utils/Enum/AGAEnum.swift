//
//  AGAEnum.swift
//  Agua
//
//  Created by Muneesh Chauhan on 13/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
// enum for storyboard
enum AGAStoryboard: String {
    case main = "Main"
    case profile = "Profile"
    case songInfo = "SongInfo"
    case bookmarkList = "BookmarkList"
    var filename: String {
        return rawValue
    }
}
enum AGAListeningMode {
    case beforeSpeak
    case duringSpeak
    case afterSpeak
    case searchingInfo
    case notFoundInfo
    case closeByUser
    case waitForHiAgua
}

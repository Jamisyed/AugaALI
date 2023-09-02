//
//  SaveSongInfoModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 08/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
// MARK: - SaveSongsInfoModel
struct SaveSongsInfoModel: Codable {
    let detail: String?
    let data: SongData?
    let error: Bool?
}

// MARK: - DataClass
struct SongData: Codable {
    let songId: Int?
    let title: String?
    let artists: [Artist]?
    let bookmark: Bookmark?
    let vid, acrid, trackID: String?
    enum CodingKeys: String, CodingKey {
        case songId = "id"
        case title, artists, bookmark, vid, acrid, trackID
    }
}

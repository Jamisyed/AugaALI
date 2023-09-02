//  Agua
//
//  Created by Muneesh Kumar on 17/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation

// MARK: - BookMarkSongsListModel
struct BookMarkSongsListModel: Codable {
    let detail: String?
    let data: BookMarkSongsListData?
    let error: Bool?
}

// MARK: - DataClass
struct BookMarkSongsListData: Codable {
    let meta: Meta?
    let result: [SongBookMarkData]?
}

// MARK: - Result
struct SongBookMarkData: Codable {
    let songBookmarkId: Int?
    let music: [Result]?
    enum CodingKeys: String, CodingKey {
        case songBookmarkId = "id"
        case music = "Music"
    }
}

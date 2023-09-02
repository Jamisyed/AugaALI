//
//  AddSongInPlayListModel.swift
//  MyNewSpotifyDemo
//
//  Created by Muneesh Kumar on 01/02/22.
//

import Foundation

// MARK: - AddSongInPlayListModel
struct AddSongInPlayListModel: Codable {
    let snapshotID: String?

    enum CodingKeys: String, CodingKey {
        case snapshotID = "snapshot_id"
    }
}

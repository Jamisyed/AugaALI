import Foundation

// MARK: - CreatePlayListModel
struct CreatePlayListModel: Codable {
    let collaborative: Bool?
    let createPlayListModelDescription: String?
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let images: [String]?
    let name: String?
    let owner: Owner?
    let primaryColor: String?
    let createPlayListModelPublic: Bool?
    let snapshotID: String?
    let tracks: Tracks?
    let type, uri: String?

    enum CodingKeys: String, CodingKey {
        case collaborative
        case createPlayListModelDescription = "description"
        case externalUrls = "external_urls"
        case followers, href, id, images, name, owner
        case primaryColor = "primary_color"
        case createPlayListModelPublic = "public"
        case snapshotID = "snapshot_id"
        case tracks, type, uri
    }
}

// MARK: - Followers
struct Followers: Codable {
    let href: String?
    let total: Int?
}

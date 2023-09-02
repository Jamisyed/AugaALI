import Foundation

// MARK: - PlayListModel
struct PlayListModel: Codable {
    let href: String?
    let items: [Item]?
    let limit, offset, previous: Int?
    let total: Int?
    let next: String?
}

// MARK: - Item
struct Item: Codable {
    let collaborative: Bool?
    let itemDescription: String?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [ImagesData]?
    let name: String?
    let owner: Owner?
    let primaryColor: String?
    let itemPublic: Bool?
    let snapshotID: String?
    let tracks: Tracks?
    let type, uri: String?

    enum CodingKeys: String, CodingKey {
        case collaborative
        case itemDescription = "description"
        case externalUrls = "external_urls"
        case href, id, images, name, owner
        case primaryColor = "primary_color"
        case itemPublic = "public"
        case snapshotID = "snapshot_id"
        case tracks, type, uri
    }
}

struct ImagesData: Codable {
    let height, width: Double?
    let url: String?
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String?
}

// MARK: - Owner
struct Owner: Codable {
    let displayName: String?
    let externalUrls: ExternalUrls?
    let href: String?
    let id, type, uri: String?

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case href, id, type, uri
    }
}

// MARK: - Tracks
struct Tracks: Codable {
    let href: String?
    let total: Int?
}

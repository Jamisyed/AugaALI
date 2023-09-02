// MARK: - AGAMusicTrack
struct AGAMusicTrack: Codable {
    let metadata: Metadata?
    let status: Status?
    let resultType: Int?
    let costTime: Double?
    
    enum CodingKeys: String, CodingKey {
        case metadata, status
        case costTime = "cost_time"
        case resultType = "result_type"
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let timestampUTC: String?
    let music: [Music]?
    let customFiles: [CustomFile]?
    enum CodingKeys: String, CodingKey {
        case customFiles = "custom_files"
        case timestampUTC = "timestamp_utc"
        case music
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each property, handling potential decoding errors
        do {
            timestampUTC = try container.decodeIfPresent(String.self, forKey: .timestampUTC)
            music = try container.decodeIfPresent([Music].self, forKey: .music)
            customFiles = try container.decodeIfPresent([CustomFile].self, forKey: .customFiles)
        } catch {
            // Handle the decoding error
            print("Error decoding Metadata: \(error)")
            // You can perform additional error handling or throw a custom error if needed
            // For example, you can assign default values or log the error for debugging purposes
            throw error
        }
    }
}
// MARK: - CustomFile
struct CustomFile: Codable {
    let dbEndTimeOffsetMS, score, durationMS: Int?
    let customData, title: String?
    let sampleEndTimeOffsetMS: Int?
    let acrid: String?
    let playOffsetMS, dbBeginTimeOffsetMS, sampleBeginTimeOffsetMS: Int?
    let bucketID: String?
    let brandName: String?
    let productName: String?
    
    enum CodingKeys: String, CodingKey {
        case brandName = "brand_name"
        case productName = "product_name"
        case dbEndTimeOffsetMS = "db_end_time_offset_ms"
        case score
        case durationMS = "duration_ms"
        case customData, title
        case sampleEndTimeOffsetMS = "sample_end_time_offset_ms"
        case acrid
        case playOffsetMS = "play_offset_ms"
        case dbBeginTimeOffsetMS = "db_begin_time_offset_ms"
        case sampleBeginTimeOffsetMS = "sample_begin_time_offset_ms"
        case bucketID = "bucket_id"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            dbEndTimeOffsetMS = try container.decodeIfPresent(Int.self, forKey: .dbEndTimeOffsetMS)
            score = try container.decodeIfPresent(Int.self, forKey: .score)
            durationMS = try container.decodeIfPresent(Int.self, forKey: .durationMS)
            customData = try container.decodeIfPresent(String.self, forKey: .customData)
            title = try container.decodeIfPresent(String.self, forKey: .title)
            sampleEndTimeOffsetMS = try container.decodeIfPresent(Int.self, forKey: .sampleEndTimeOffsetMS)
            acrid = try container.decodeIfPresent(String.self, forKey: .acrid)
            playOffsetMS = try container.decodeIfPresent(Int.self, forKey: .playOffsetMS)
            dbBeginTimeOffsetMS = try container.decodeIfPresent(Int.self, forKey: .dbBeginTimeOffsetMS)
            sampleBeginTimeOffsetMS = try container.decodeIfPresent(Int.self, forKey: .sampleBeginTimeOffsetMS)
            bucketID = try container.decodeIfPresent(String.self, forKey: .bucketID)
            brandName = try container.decodeIfPresent(String.self, forKey: .brandName)
            productName = try container.decodeIfPresent(String.self, forKey: .productName)
        } catch {
            print("Error decoding CustomFile: \(error)")
            throw error
        }
    }
}
struct Genres: Codable {
    let generesArr: [TrackClass]?
}
// MARK: - Music
struct Music: Codable {
    let dbBeginTimeOffsetMS, dbEndTimeOffsetMS, sampleBeginTimeOffsetMS, sampleEndTimeOffsetMS: Int?
    let playOffsetMS: Int64?
    let artists: [MusicAlbum]?
    let lyrics: Lyrics?
    let acrid: String?
    let album: MusicAlbum?
    let rightsClaim: [RightsClaim]?
    let externalIDS: ExternalIDS?
    let genres: [Genres]?
    let resultFrom: Int?
    let contributors: Contributors?
    let title, language: String?
    let durationMS: Int64?
    let label: String?
    let externalMetadata: ExternalMetadata?
    let score: Int?
    let releaseDate: String?
    let releaseByTerritories: [ReleaseByTerritory]?
    enum CodingKeys: String, CodingKey {
        case genres
        case dbBeginTimeOffsetMS = "db_begin_time_offset_ms"
        case dbEndTimeOffsetMS = "db_end_time_offset_ms"
        case sampleBeginTimeOffsetMS = "sample_begin_time_offset_ms"
        case sampleEndTimeOffsetMS = "sample_end_time_offset_ms"
        case playOffsetMS = "play_offset_ms"
        case artists, lyrics, acrid, album
        case rightsClaim = "rights_claim"
        case externalIDS = "external_ids"
        case resultFrom = "result_from"
        case contributors, title, language
        case durationMS = "duration_ms"
        case label
        case externalMetadata = "external_metadata"
        case score
        case releaseDate = "release_date"
        case releaseByTerritories = "release_by_territories"
    }
}
// MARK: - MusicAlbum
struct MusicAlbum: Codable {
    let name: String?
    let musicAlbumId: Int?
    enum CodingKeys: String, CodingKey {
        case name
        case musicAlbumId = "id"
    }
    
    
    
}

// MARK: - Contributors
struct Contributors: Codable {
    let composers, lyricists: [String]?
}

// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    let iswc, isrc, upc: String?
}

// MARK: - ExternalMetadata
struct ExternalMetadata: Codable {
    // let musicbrainz: [Musicbrainz]?
    let deezer, spotify: Deezer?
    // let musicstory: Musicstory?
    let youtube: Youtube?
}


struct DeezerAlbum: Codable {
    let trackId: Int?
    let name: String?
}
// MARK: - Deezer
struct Deezer: Codable {
    let track: DeezerAlbum?
    let artists: [DeezerAlbum]?
    let album: DeezerAlbum?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            track = try container.decodeIfPresent(DeezerAlbum.self, forKey: .track)
            artists = try container.decodeIfPresent([DeezerAlbum].self, forKey: .artists)
            album = try container.decodeIfPresent(DeezerAlbum.self, forKey: .album)
        } catch {
            print("Error decoding Deezer: \(error)")
            throw error
        }
    }
}

// MARK: - TrackClass
enum IdAny: Codable {
    case numeric(value: Int)
    case named(name: String)
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let obj = try? container.decode(String.self) {
            self = .named(name: obj)
            return
        }
        if let obj = try? container.decode(Int.self) {
            self = .numeric(value: obj)
            return
        }else {
            throw DecodingError.typeMismatch(IdAny.self,DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .named(let obj):
            try container.encode(obj)
        case .numeric(let obj):
            try container.encode(obj)
        }
    }
}
struct TrackClass: Codable {
    var name: String?
    var trackId: String?
    enum CodingKeys: String, CodingKey {
        case name
        case trackId = "id"
    }
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            name = try container.decodeIfPresent(String.self, forKey: .name)
            //trackId = try container.decodeIfPresent(String.self, forKey: .trackId)
            if let trackIdString = try container.decodeIfPresent(String.self, forKey: .trackId) {
                // trackId = trackIdString
                trackId = "nil"
            } else if let trackIdInt = try container.decodeIfPresent(Int.self, forKey: .trackId) {
                //   trackId = String(trackIdInt)
                trackId = String(23)
            } else {
                trackId = nil
            }
        }catch let error as DecodingError {
            switch error {
            case .typeMismatch(let type, let context):
                // Handle the type mismatch error
                print("Type mismatch error occurred during decoding.")
                print("Expected type: \(type)")
                print("Context: \(context)")
                // You can handle the error in a way that makes sense for your application
                // For example, you can assign a default value or display an error message to the user.
            default:
                // Handle other decoding errors
                print("An error occurred during decoding: \(error)")
            }
        } catch {
            // Handle other errors
            print("An error occurred: \(error)")
        }
     
    }
}

// MARK: - Musicbrainz
struct Musicbrainz: Codable {
    let track: TrackClass?
}

// MARK: - Musicstory
struct Musicstory: Codable {
    let track, album: TrackClass?
}

// MARK: - Youtube
struct Youtube: Codable {
    let vid: String?
}

// MARK: - Lyrics
struct Lyrics: Codable {
    let copyrights: [String]?
}

// MARK: - ReleaseByTerritory
struct ReleaseByTerritory: Codable {
    let territories: [String]?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case territories
        case releaseDate = "release_date"
    }
}

// MARK: - RightsClaim
struct RightsClaim: Codable {
    let rightsOwners: [RightsOwner]?
    let rightsClaimPolicy: String?
    let territories, excludedTerritories: [String]?
    
    enum CodingKeys: String, CodingKey {
        case rightsOwners = "rights_owners"
        case rightsClaimPolicy = "rights_claim_policy"
        case territories
        case excludedTerritories = "excluded_territories"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            rightsOwners = try container.decodeIfPresent([RightsOwner].self, forKey: .rightsOwners)
            rightsClaimPolicy = try container.decodeIfPresent(String.self, forKey: .rightsClaimPolicy)
            territories = try container.decodeIfPresent([String].self, forKey: .territories)
            excludedTerritories = try container.decodeIfPresent([String].self, forKey: .excludedTerritories)
        } catch {
            print("Error decoding RightsClaim: \(error)")
            throw error
        }
    }
}

// MARK: - RightsOwner
struct RightsOwner: Codable {
    let name: String?
    let sharePercentage: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case sharePercentage = "share_percentage"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            name = try container.decodeIfPresent(String.self, forKey: .name)
            sharePercentage = try container.decodeIfPresent(Int.self, forKey: .sharePercentage)
        } catch {
            print("Error decoding RightsOwner: \(error)")
            throw error
        }
    }
}

// MARK: - Status
struct Status: Codable {
    let msg, version: String?
    let code: Int?
}

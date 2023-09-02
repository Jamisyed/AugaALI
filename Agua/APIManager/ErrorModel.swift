//
//  ErrorModel.swift

import Foundation
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case longitude = "longitude"
    case latitude = "latitude"
}
enum ContentType: String {
    case json = "application/json"
    case formData = "multipart/form-data"
}

struct ErrorObj: Codable {
    var detail: String?
    private enum CodingKeys: String, CodingKey {
        case detail
    }
}

// CustomError Object model call when API fail.
struct CustomError: OurErrorProtocol {
    var detail: String?
    var code: Int?
    init() {
        detail = "Error"
    }
    init(message: String?, code: Int?) {
        self.detail = message ?? ""
        self.code = code
    }
    static func defaultError() -> CustomError {
        return CustomError(message: "", code: nil)
    }
}
protocol OurErrorProtocol: LocalizedError {
    var detail: String? { get }
    var code: Int? { get }
}

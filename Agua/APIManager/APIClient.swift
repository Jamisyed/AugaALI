import Alamofire
import SwiftyJSON
class APIClient: NSObject {
    // MARK: - Vars & Lets
    private let sessionManager: Session
    // MARK: - Public methods
    var apiSucess = [200, 201, 202, 204]
    
    func cancelAllRequest() {
        self.sessionManager.session.getAllTasks { (task) in
            task.forEach { $0.cancel() }
        }
    }
    func request(path: APIRouter, handler: @escaping (Swift.Result<(), CustomError>) -> Void) {
        guard ConnectivityUtils.isConnectedToNetwork() else {
            handler(.failure(CustomError(message: "No network available, please try again later.", code: nil)))
            return
        }
        self.sessionManager.request(path).validate().responseJSON { (data) in
            switch data.result {
            case .success:
                handler(.success(()))
            case .failure:
                handler(.failure(self.parseApiError(data: data.data)))
            }
        }
    }
    func request<T: Codable>(path: APIRouter,
                             handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        guard ConnectivityUtils.isConnectedToNetwork() else {
            handler(.failure(CustomError(message: "No network available, please try again later.", code: nil)))
            return
        }
        print(path)
        self.sessionManager.request(path).validate()
            .responseJSON { (data) in
                switch data.result {
                case .success:
                    do {
                        guard let jsonData = data.data else {
                            throw  CustomError(message: nil, code: nil)
                        }
                        if let code = data.response?.statusCode,
                           !self.apiSucess.contains(code) {
                            throw self.parseApiError(data: data.data)
                        } else {
                            let result = try JSONDecoder().decode(T.self, from: jsonData)
                            handler(.success(result))
                        }
                    } catch {
                        debugPrint(error)
                        if let error = error as? CustomError {
                            handler(.failure(error))
                        }
                        handler(.failure(self.parseApiError(data: data.data)))
                    }
                case .failure:
                    handler(.failure(self.parseApiError(data: data.data)))
                }
            }
    }
    fileprivate func handleFileUpload<T: Codable>(_ upload: DataRequest,
                                                  handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        upload.responseData(completionHandler: { (data) in
            switch data.result {
            case .success:
                do {
                    guard let jsonData = data.data else {
                        throw  CustomError(message: nil, code: nil)
                    }
                    if let code = data.response?.statusCode,
                       !self.apiSucess.contains(code) {
                        throw self.parseApiError(data: data.data)
                    } else {
                        let result = try JSONDecoder().decode(T.self, from: jsonData)
                        handler(.success(result))
                    }
                } catch {
                    if let error = error as? CustomError {
                        handler(.failure(error))
                    }
                    handler(.failure(self.parseApiError(data: data.data)))
                }
            case .failure:
                handler(.failure(self.parseApiError(data: data.data)))
            }
        })
    }
    func request<T: Codable>(path: APIRouter,
                             imageDic: [ImageDic],
                             handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        guard ConnectivityUtils.isConnectedToNetwork() else {
            handler(.failure(CustomError(message: "No network available, please try again later.",
                                         code: nil)))
            return
        }
        let uploadResponse = self.sessionManager.upload(multipartFormData: { multipartFormData in
            for obj in imageDic where obj.data.count != 0 {
                multipartFormData.append(obj.data,
                                         withName: obj.key.rawValue,
                                         fileName: obj.filename,
                                         mimeType: obj.mimeType.rawValue )
            }
            for (key, value) in path.parameters ?? [:] {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key )
            }
        }, with: path)
        handleFileUpload(uploadResponse, handler: { result in
            handler(result)
        })
    }
    private func parseApiError(data: Data?) -> CustomError {
        let decoder = JSONDecoder()
        if let jsonData = data, let error = try? decoder.decode(ErrorObj.self, from: jsonData) {
            return CustomError(message: error.detail, code: nil)
        }
        return CustomError.defaultError()
    }
    // MARK: - Initialization
    init(sessionManager: Session) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 120
        let sessionManager = Session(configuration: configuration)
        self.sessionManager = sessionManager
    }
}

struct ImageDic {
    var filename: String!
    var data: Data!
    var key: ParameterKey = .none
    var mimeType: MimeType = .png
    init(_ filename: String? =  nil, data: Data, key: ParameterKey, mimeType: MimeType? = nil) {
        self.filename = filename ??  "img\(Float.random(in: 1..<10000))).png"
        self.data = data
        self.key = key
        self.mimeType = mimeType ?? .png
    }
}
enum MimeType: String {
    case png = "image/png"
}

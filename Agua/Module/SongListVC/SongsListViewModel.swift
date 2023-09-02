//
//  SongsListViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 08/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//
enum LoadMoreState {
    case initiated, none, loaded
}
enum RecognitionType {
    case songs
    case products
}
import Foundation
import Alamofire
class SongsListViewModel {
    var resultArr = [Result]() // songs list response model
    var currentPage = 1
    var lastPage = 1
    var loadState = LoadMoreState.none
    // var newlyAddedRecord: Result?
    // response data
    var titleName = ""
    var trackID = ""
    var artistName = ""
    var label = ""
    var vid = ""
    var selectedRow = 0 // selected row for which detail displayed
    var songJustIdentified = false
    var isSongInfoSaved = false // if save info not saved by voice command - save it without book mark
    var speakString = ""
    var subStringArray: [String] = []
    var timerForUserNoSpeak = Timer()
    var timerForUserCompleteCommand = Timer()
    var detectionTimer = Timer()
    var nameOfSong = ""
    var nameOfArtist = ""
    var recognitionType = RecognitionType.songs
    var productDetailFieldsModel: ProductFieldModel?
    func hitAPI<T: Codable>(route: APIRouter,
                            handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        let apiManager = APIClient(sessionManager: Session())
        apiManager.request(path: route) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
}
struct ProductFieldModel {
    var productName: String?
    var brandName: String?
    var vId: String?
    var acrId: String?
    var isSubscribed: Bool?
}

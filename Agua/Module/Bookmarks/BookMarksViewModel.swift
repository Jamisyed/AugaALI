//
//  BookMarksViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 15/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
import Alamofire
enum BookMarkListType {
    case songs
    case product
}
class BookMarksViewModel {
    var bookmarkListType = BookMarkListType.songs
    var resultArr = [SongBookMarkData]()
    var productsArr = [Result]()
    var selectedCollectionRow = 0
    var currentPage = 1
    var lastPage = 1
    var loadState = LoadMoreState.none
    func getListData<T: Codable>(route: APIRouter,
                                 handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
       
        
        let apiManager = APIClient(sessionManager: Session())
    
        apiManager.request(path: route) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
}

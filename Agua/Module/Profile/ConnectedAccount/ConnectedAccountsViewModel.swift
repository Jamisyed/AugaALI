//
//  ConnectedAccountsViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 03/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
import Alamofire
class ConnectedAccountsViewModel {
    var dataSource = [ProfileModel]()
    func createDataSource() {
        //MARK:  Remove Spotify Cell Because of Apple Restriction 
      //  dataSource.append(ProfileModel(cellType: .spotify, connctedState: false))
        dataSource.append(ProfileModel(cellType: .amazon, connctedState: false))
    }
    func saveSpotifyToken<T: Codable>(route: APIRouter,
                                 handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        let apiManager = APIClient(sessionManager: Session())
        apiManager.request(path: route) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
}

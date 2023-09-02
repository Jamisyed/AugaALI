//
//  ProfileViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 02/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
import Alamofire
class ProfileViewModel {
    var dataSource = [ProfileModel]()
    var image: UIImage?
    var userProfile: UserProfile?
    var showRemovePicOption = false
    func createDataSource() {
        dataSource.append(ProfileModel(cellType: .bookmark, connctedState: false))
        // MARK: Remove payment methos and Connect Account Cell
      //  dataSource.append(ProfileModel(cellType: .paymentMethods, connctedState: false))
       //dataSource.append(ProfileModel(cellType: .connectAccounts, connctedState: false))
        dataSource.append(ProfileModel(cellType: .termsAndCondition, connctedState: false))
        dataSource.append(ProfileModel(cellType: .privacy, connctedState: false))
        dataSource.append(ProfileModel(cellType: .howToUse, connctedState: false))
        dataSource.append(ProfileModel(cellType: .playAdv, connctedState: false))
        dataSource.append(ProfileModel(cellType: .deleteAccount, connctedState: false))
        dataSource.append(ProfileModel(cellType: .logout, connctedState: false))
    }
    func callAPI<T: Codable>(route: APIRouter, handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        let apiManager = APIClient(sessionManager: Session())
        apiManager.request(path: route) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
    func updateProfilePic<T: Codable>(route: APIRouter,
                                      imageDic: [ImageDic],
                                      handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        let apiManager = APIClient(sessionManager: Session())
        apiManager.request(path: route, imageDic: imageDic) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
}

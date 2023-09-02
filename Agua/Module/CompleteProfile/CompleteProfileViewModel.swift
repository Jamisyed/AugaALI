//
//  CompleteProfileViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 01/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
class CompleteProfileViewModel {
    var userName = ""
    var image: UIImage?
    func completeYourProfile<T: Codable>(route: APIRouter,
                                         imageDic: [ImageDic],
                                         handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        let apiManager = APIClient(sessionManager: Session())
        apiManager.request(path: route, imageDic: imageDic) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
    func validateIfUserNameIsEmpty() -> Bool {
        return userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? true : false
    }
    func validateIfProfilePicIsEmpty() -> Bool {
        return image == nil ? true : false
    }
}

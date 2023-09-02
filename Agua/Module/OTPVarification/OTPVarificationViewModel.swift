//
//  OTPVarificationViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 29/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import Foundation
import Alamofire

class OTPVarificationViewModel {
    var email = ""
    var mobile = ""
    func hitAPI<T: Codable>(route: APIRouter,
                            handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        let apiManager = APIClient(sessionManager: Session())
        apiManager.request(path: route) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
}

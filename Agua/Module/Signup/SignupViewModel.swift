//
//  SignupViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 23/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import Foundation
import Alamofire
class SignUpViewModel {
    var isCheckMarkSelected = false
    var emailErrorMessage = ""
    var mobileErrorMessage = ""
    var email = ""
    var mobile = ""
    func callAPI<T: Codable>(route: APIRouter, handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        let apiManager = APIClient(sessionManager: Session())
        apiManager.request(path: route) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
}

//
//  AGALoginViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 25/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import Foundation
import Alamofire
class AGALoginViewModel {
    var mobile = ""
    var mobileError = ""
    func checkValidation() -> String {
        if mobile.isEmpty {
            return AGAStringConstants.Validations.emptyMobile
        }
        if !checkIfValidMobileNumber() {
            return AGAStringConstants.Validations.invalidMobile
        }
        return ""
    }
    private func checkIfValidMobileNumber() -> Bool {
        if mobile.count == AGANumericConstants.ten || mobile.count == AGANumericConstants.k12 { return true }
        return false
    }

    func hitAPI<T: Codable>(route: APIRouter,
                            handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        let apiManager = APIClient(sessionManager: Session())
        apiManager.request(path: route) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
}

//
//  PopUpViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 15/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

enum UpdateField {
    case email
    case mobile
}
struct PopUpModel {
    var updateField = UpdateField.email
    var title = ""
    var description = ""
    var text = ""
    var error = ""
}
import Foundation
import Alamofire
class PopUpViewModel {
    var model = PopUpModel()
    var otp = ""
    func validateEmail() -> Bool {
        return model.text.isValidEmail()
    }
    func validateMobile() -> Bool {
        if model.text.count == AGANumericConstants.ten || model.text.count == AGANumericConstants.k12 { return true }
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

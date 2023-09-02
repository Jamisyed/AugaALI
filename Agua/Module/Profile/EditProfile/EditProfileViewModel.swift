//
//  EditprofileViewModel.swift
//  Agua
//
//  Created by Muneesh Kumar on 14/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

struct EditProfiledModel {
    var fieldType: SignUpTextFieldType
    var text: String
}
import Foundation
import UIKit
import Alamofire
class EditProfileViewModel {
    var dataSource = [EditProfiledModel]()
    var image: UIImage?
    var userProfile: UserProfile?
    var isRemovePicOption = false
    func createDataSource() {
        dataSource.append(EditProfiledModel(fieldType: .userName(validationError: ""), text: userProfile?.data?.userName ?? ""))
        dataSource.append(EditProfiledModel(fieldType: .email(validationError: ""), text: userProfile?.data?.email ?? ""))
        let phone = (userProfile?.data?.phone ?? "").replacingOccurrences(of: "+1", with: "")
        dataSource.append(EditProfiledModel(fieldType: .mobile(validationError: ""), text: phone))
    }
    func completeYourProfile<T: Codable>(route: APIRouter,
                                             imageDic: [ImageDic],
                                         handler: @escaping (Swift.Result<T, CustomError>) -> Void) {
        let apiManager = APIClient(sessionManager: Session())
        apiManager.request(path: route, imageDic: imageDic) { (response: Swift.Result<T, CustomError>) in
            handler(response)
        }
    }
    func validateIfUserNameIsEmpty() -> Bool {
        return dataSource.first?.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? false ? true : false
    }
    func validateIfProfilePicIsEmpty() -> Bool {
        return image == nil ? true : false
    }
}

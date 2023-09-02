//
//  ParameterEncoding.swift
//  FinaBet

import Foundation
import Alamofire
extension APIRouter {
      var encoding: ParameterEncoding {
        switch self {
       // case .none:
       //     return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

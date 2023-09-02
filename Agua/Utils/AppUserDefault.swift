import Foundation
import UIKit

enum UserDefaultKeys: String {
    case userToken
    case spotifyAccessToken
    case accessToken = "access_token"
    case isLoggedIn
}

class AppUserDefault: NSObject {
    class var userDefault: UserDefaults {
        return UserDefaults.standard
    }
    // MARK: -  save user is login
    class func setIsLogin(login: Bool) {
        UserDefaults.standard.set(login, forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    class func setStringValueForKey(key: UserDefaultKeys, value: String) {
        userDefault.set(value, forKey: key.rawValue)
        userDefault.synchronize()
    }
    class func setValueForKey(key: UserDefaultKeys, value: Int) {
        userDefault.set(value, forKey: key.rawValue)
        userDefault.synchronize()
    }
    class func setValueForKey(key: UserDefaultKeys, value: Bool) {
        userDefault.set(value, forKey: key.rawValue)
        userDefault.synchronize()
    }
    // MARK: -  get user is login or not. Bool
    class func getIsLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    class func getStringValue(key: UserDefaultKeys) -> String? {
        if let value = userDefault.object(forKey: key.rawValue) {
            return value as? String
        } else {
            return nil
        }
    }
    class func getBoolValue(key: UserDefaultKeys) -> Bool? {
        if let value = userDefault.object(forKey: key.rawValue) {
            return value as? Bool
        } else {
            return nil
        }
    }
    class func getIntValue(key: UserDefaultKeys) -> Int {
        guard let value = userDefault.object(forKey: key.rawValue) as? Int
        else { return 0 }
        return value
    }
    class func getValueForKey(key: UserDefaultKeys) -> Any? {
        return userDefault.object(forKey: key.rawValue)
    }
    class func removeValueForKey(key: UserDefaultKeys) {
        userDefault.removeObject(forKey: key.rawValue)
        userDefault.synchronize()
    }
}

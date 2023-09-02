import Foundation
import UIKit

enum LoginStatus: String {
    case loggedIn
    case loggedOut
    var boolValue: Bool {
        switch self {
        case .loggedIn:
            return true
        case .loggedOut:
            return false
        }
    }
}

enum LaunchOption {
    case login, home, launch
}

class AppManager {
    static let sharedInstance = AppManager()
    static let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    private init() {}
    static var loginStatus: LoginStatus {
        if AppUserDefault.getStringValue(key: .userToken) != nil {
            return LoginStatus.loggedIn
        }
        return LoginStatus.loggedOut
    }
    static func launchScreen() -> UINavigationController? {
        return openController(with: LaunchOption.launch, present: false)
    }
    @discardableResult
    static func openController(with type: LaunchOption,
                               present: Bool = false) -> UINavigationController? {
        let nav = UINavigationController()
        nav.navigationBar.isHidden = true
        switch type {
        case .launch:
            if loginStatus == .loggedOut {
                if let welcomeVC = vcFactory.welcomeVC() {
                    nav.viewControllers =  [welcomeVC]
                }
            } else {
                if let homeVC = vcFactory.instatiateHomeVC() {
                    nav.viewControllers =  [homeVC]
                }
            }
        case .login: break
        case .home: break
        }
        if present {
            return nav
        }
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
                return nil
            }
            sceneDelegate.window?.rootViewController = nav
        } else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = nav
                appDelegate.window?.makeKeyAndVisible()
            }
        }
        return nil
    }
}

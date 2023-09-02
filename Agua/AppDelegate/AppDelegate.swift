//
//  AppDelegate.swift
//  Agua
//
//  Created by Muneesh Chauhan on 11/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import UIKit
import Speech
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
            IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
            IQKeyboardManager.shared.enableAutoToolbar = false
            IQKeyboardManager.shared.keyboardDistanceFromTextField = 20

        // Override point for customization after application launch.
    Thread.sleep(forTimeInterval: TimeInterval(AGANumericConstants.five))
        return true
    }
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        self.disableAVSession()
    }
    private func disableAVSession() {
        do {
            print("audioSession properties disable.")
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't disable.")
        }
    }
}

//
//  AdvertisementHandlar.swift
//  Agua
//
//  Created by Muneesh Kumar on 09/03/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
import UIKit
class AdvertisementHandlar {
    static let shared = AdvertisementHandlar()
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    private var timer: Timer?
    var switchState = false
    private init() {
    }
    func updateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    func stopTimer() {
        timer = nil
    }
    @objc func updateCounting() {
        if let topController = UIApplication.topViewController() {
            if topController != vcFactory.playAdv() && switchState {
                guard let viewController = vcFactory.playAdv() else {
                    return
                }
                let navigationController = UINavigationController(rootViewController: viewController)
            topController.present(navigationController, animated: true, completion: nil)
            }
        }
    }
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

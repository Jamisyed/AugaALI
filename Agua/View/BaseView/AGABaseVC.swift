//
//  AGABaseVC.swift
//  Agua
//
//  Created by Muneesh Chauhan on 13/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import UIKit
import SwiftEntryKit
enum AGANotificationType {
    case error
    case success
}
class AGABaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    func addGradient(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.gradiantDarkColor.cgColor, UIColor.gradiantLightColor.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    /// This function add Banner at top
    func showPopNotificationView(notiMessage: String, notificationType: AGANotificationType) {
        if let notificationBannerView = AGANotificationBannerView.instanceFromNib() as? AGANotificationBannerView {
            notificationBannerView.alertString.text = notiMessage
            notificationBannerView.bgView.backgroundColor = UIColor.clear
            var attributes = EKAttributes()
            attributes.position = .top
            attributes.displayDuration = EKAttributes.DisplayDuration(AGANumericConstants.three)
            let heightConstraint = EKAttributes
                .PositionConstraints.Edge.constant(value: CGFloat(AGANumericConstants.fiftySix))
                   let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.8)
                   attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
            attributes.roundCorners = EKAttributes.RoundCorners.all(radius: 8.0)
                   SwiftEntryKit.display(entry: notificationBannerView, using: attributes)
        }
    }
    func setGradientBackground() {
        let colorTop =  UIColor(red: 39.0/255.0, green: 47.0/255.0, blue: 70.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 14.0/255.0, green: 17.0/255.0, blue: 26.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

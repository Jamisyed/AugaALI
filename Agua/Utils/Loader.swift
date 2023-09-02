//
//  Loader.swift
//  Questie
//
//  Created by Neelam Yadav on 04/12/20.
//  Copyright © 2020 Neelam Yadav. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class Loader: NSObject {
    static let loaderRadius: CGFloat = 50
    static let loaderColor = UIColor.greenColor
    static let loaderBgColor = UIColor.clear
    static let baseView: UIView = UIView()
    static let baseLoadingView: UIView = UIView()
    static var activityIndicatorView: NVActivityIndicatorView!

    class func addLoader(_ view: UIView, loaderColor: UIColor = UIColor.black) {
        self.removeLoader()
        // removal of activity indicator before adding
        // to base view, check if already added to base view
        baseView.backgroundColor = UIColor.clear
        baseView.frame = view.frame
        let frame = CGRect(x: (view.frame.size.width-loaderRadius)/2,
                           y: (view.frame.size.height-loaderRadius)/2,
                           width: loaderRadius, height: loaderRadius)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: .circleStrokeSpin,
                                                        color: Loader.loaderColor,
                                                        padding: 0)

        baseLoadingView.frame = CGRect(x: (view.frame.size.width-loaderRadius)/2 - 10,
                                       y: (view.frame.size.height-loaderRadius)/2 - 10,
                                       width: loaderRadius+20,
                                       height: loaderRadius+20)
        baseLoadingView.layer.cornerRadius = 10
        baseLoadingView.layer.borderWidth = 0
        baseLoadingView.layer.borderColor = Loader.loaderBgColor.cgColor
        baseLoadingView.backgroundColor = UIColor.clear
        baseView.addSubview(baseLoadingView)
        baseView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        view.addSubview(baseView)
    }
    class func spinnerAnimiation(view: UIView) {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: .circleStrokeSpin,
                                                        color: .white, padding: 8)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        activityIndicatorView.startAnimating()
    }
    class func addLoaderForInAppPurchase(_ view: UIView,
                                         withYAxisHeight height: CGFloat) {

        self.removeLoader()
        // removal of activity indicator before adding
        // to base view, check if already added to base view
        baseView.backgroundColor = UIColor.clear
        baseView.frame = view.frame
        baseLoadingView.frame = CGRect(x: (view.frame.size.width-loaderRadius)/2 - 10,
                                       y: ((view.frame.size.height-loaderRadius)/2 - height) - 25,
                                       width: loaderRadius+20, height: loaderRadius+20)
        let frame = CGRect(x: (baseLoadingView.frame.size.width-loaderRadius)/2,
                           y: ((baseLoadingView.frame.size.height-loaderRadius)/2),
                           width: loaderRadius, height: loaderRadius)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: .lineScale,
                                                        color: Loader.loaderColor,
                                                        padding: 0)
        baseLoadingView.layer.cornerRadius = 10
        baseLoadingView.layer.borderWidth = 0
        baseLoadingView.layer.borderColor = Loader.loaderBgColor.cgColor
        baseLoadingView.backgroundColor = UIColor.clear
        baseView.addSubview(baseLoadingView)
        baseLoadingView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        view.addSubview(baseView)
    }

    class func removeLoader() {
        if activityIndicatorView != nil {
            DispatchQueue.main.async {
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
                baseView.removeFromSuperview()
            }
        }
    }
}

class InstanceLoader: NSObject {

    let loaderRadius: CGFloat = 50
    let baseView: UIView = UIView()
    let baseLoadingView: UIView = UIView()
    var activityIndicatorView: NVActivityIndicatorView!
    var isRunning: Bool!

    func addLoader(_ view: UIView, loaderColor: UIColor = UIColor.black) {
        // removal of activity indicator before adding to base view,
        // check if already added to base view
        self.removeLoader()
        self.isRunning = true
        baseView.backgroundColor = UIColor.clear
        baseView.frame = view.frame
        let frame = CGRect(x: (view.frame.size.width-loaderRadius)/2,
                           y: (view.frame.size.height-loaderRadius)/2,
                           width: loaderRadius, height: loaderRadius)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: .circleStrokeSpin,
                                                        color: Loader.loaderColor,
                                                        padding: 0)
        baseLoadingView.frame = CGRect(x: (view.frame.size.width-loaderRadius)/2 - 10,
                                       y: (view.frame.size.height-loaderRadius)/2 - 10,
                                       width: loaderRadius+20,
                                       height: loaderRadius+20)
        baseLoadingView.layer.cornerRadius = 10
        baseLoadingView.layer.borderWidth = 0
        baseLoadingView.layer.borderColor = Loader.loaderBgColor.cgColor
        baseLoadingView.backgroundColor = UIColor.clear
        baseView.addSubview(baseLoadingView)
        baseView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        view.addSubview(baseView)
    }
     func removeLoader() {
         if activityIndicatorView != nil {
            self.isRunning = false
            activityIndicatorView?.stopAnimating()
            activityIndicatorView?.removeFromSuperview()
            baseView.removeFromSuperview()
        }

    }
}

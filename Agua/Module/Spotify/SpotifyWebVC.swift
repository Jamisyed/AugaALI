//
//  SpotifyWebVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 01/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import UIKit
import WebKit

class SpotifyWebVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    public var completionHandlar: ((Bool) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            prefs.allowsContentJavaScript = true
        } else {
            // Fallback on earlier versions
        }
        webView.navigationDelegate = self
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SpotifyWebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        // Exchange the code for access token
        let component = URLComponents(string: url.absoluteString)
        guard let code  = component?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        print("CODE: \(code)")
        AuthManager.shared.exchangeCodeForToken(code: code) {[weak self] success in
            self?.completionHandlar?(success)
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

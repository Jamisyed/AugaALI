//
//  WebKitVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 27/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import UIKit
import WebKit
class WebKitVC: AGABaseVC {
    var urlStr = ""
    @IBOutlet weak var webKitView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: urlStr)!
        webKitView.load(URLRequest(url: url))
        webKitView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGradientBackground()
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

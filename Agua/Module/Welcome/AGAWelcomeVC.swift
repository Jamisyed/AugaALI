//
//  AGAWelcomeVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 23/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import UIKit

class AGAWelcomeVC: AGABaseVC {
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func signUpAction(_ sender: UIButton) {
        guard let viewController = vcFactory.instatiateSignUp() else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func signInAction(_ sender: UIButton) {
        guard let viewController = vcFactory.instatiateSignIn() else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

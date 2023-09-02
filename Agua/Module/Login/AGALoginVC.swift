//
//  ViewController.swift
//  Agua
//
//  Created by Muneesh Chauhan on 11/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class AGALoginVC: AGABaseVC {
    @IBOutlet weak var mobileTxtField: KTTextField!
    @IBOutlet weak var errorLbl: UILabel!
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    @IBOutlet weak var continueButtonBottomConstraints: NSLayoutConstraint!
    var viewModel = AGALoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGradientBackground()
        mobileTxtField.becomeFirstResponder()
        subscribeToShowKeyboardNotifications()
    }
    func subscribeToShowKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        if let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardSize.cgRectValue.height
            continueButtonBottomConstraints.constant = keyboardHeight + CGFloat(AGANumericConstants.k20)
        }
    }

    @IBAction func crossBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func continueAction(_ sender: UIButton) {
        let errorString = viewModel.checkValidation()
        if !errorString.isEmpty {
            errorLbl.text = errorString
            return
        }
        sendOTPAPI()
    }
    private func navigateToOTPScreen() {
        guard let otpVC = vcFactory.instatiateOTP() else { return }
        otpVC.loginType = .login
        otpVC.viewModel.mobile = viewModel.mobile
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    /// remove keyboard on touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func sendOTPAPI() {
        Loader.spinnerAnimiation(view: self.view)
        let apiRouter = APIRouter.sendOTP(mobile: viewModel.mobile)
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<SendOTPModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success:
                self?.navigateToOTPScreen()
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
}

// MARK: - UITextField Delegate methods

extension AGALoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == " " || string == "." { return false }
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if updatedString?.count ?? 0 > AGANumericConstants.k12 { return false}
        viewModel.mobile = updatedString ?? ""
        errorLbl.text = ""
        return true
    }
}

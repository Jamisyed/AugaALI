//
//  OTPVarificationVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 25/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import UIKit
import Alamofire

enum LoginType {
    case login
    case signup
}
class OTPVarificationVC: AGABaseVC {

    @IBOutlet weak var mobileNumberLbl: KTLabel!
    @IBOutlet weak var otpContainerView: UIView!
    let otpStackView = OTPStackView()
    @IBOutlet weak var rightmarkView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var verifyCodeButton: KTButton!
    var resendOtpTimer: Timer?
    var count = AGANumericConstants.thirty
    var viewModel = OTPVarificationViewModel()
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    var loginType = LoginType.signup
    var disableContinue: Bool = false {
        didSet {
            if disableContinue {
                verifyCodeButton.alpha = 0.5
                verifyCodeButton?.isUserInteractionEnabled = false
            } else {
                verifyCodeButton.alpha = 1.0
                verifyCodeButton?.isUserInteractionEnabled = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNumberLbl.text = viewModel.mobile
        setGradientBackground()
        loaderView.isHidden = true
        disableContinue = true
        startResendTime()
        setupOTPContainer()
        if loginType == .login {
            self.count = 30
            self.startResendTime()
        }
    }
    private func setupOTPContainer() {
        otpContainerView.addSubview(otpStackView)
        otpStackView.delegate = self
        otpStackView.heightAnchor.constraint(equalTo: otpContainerView.heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: otpContainerView.centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpContainerView.centerYAnchor).isActive = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        otpStackView.textFieldsCollection.first?.becomeFirstResponder()
    }
    func startResendTime() {
        resendOtpTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(resendBtnSetup), userInfo: nil, repeats: true)
    }
    @objc func resendBtnSetup() {
        count -= 1
        let underLine = count > 0 ? 0 : 1
        let font = UIFont(name: AGAFont.Lexend.kRegular, size: CGFloat(AGANumericConstants.k12)*screenScaleFactor)
        let attrs = [NSAttributedString.Key.font: font!,
                     NSAttributedString.Key.foregroundColor: UIColor.greenColor,
                     NSAttributedString.Key.underlineStyle: underLine] as [NSAttributedString.Key: Any]
        var resendText = "Resend Code"
        if count > 0 {
            let time = count < 10 ? "00:0\(count)" : "00:\(count)"
            resendText += " in \(time)"
            resendCodeButton.isUserInteractionEnabled = false
        } else {
            resendOtpTimer?.invalidate()
            resendCodeButton.isUserInteractionEnabled = true
        }
        let attributedString = NSMutableAttributedString(string: "")
        let buttonTitleStr = NSMutableAttributedString(string: resendText, attributes: attrs)
        attributedString.append(buttonTitleStr)
        resendCodeButton.setAttributedTitle(attributedString, for: .normal)
    }
    @IBAction func resendCodeTapped(_ sender: UIButton) {
        if loginType == .login {
            sendOTPAPI()
        } else {
            sendOTPForSignup()
        }
    }
    func sendOTPForSignup() {
        Loader.spinnerAnimiation(view: self.view)
        let apiRouter = APIRouter.signup(email: viewModel.email, phone: viewModel.mobile, otp: "")
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<LoginModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success: print("OTP sent")
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    // this is for re-send OTP at signup
    func signUpAPI() {
        Loader.spinnerAnimiation(view: self.view)
        let apiRouter = APIRouter.signup(email: viewModel.email, phone: viewModel.mobile, otp: "")
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<LoginModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success:
                self?.count = 30
                self?.startResendTime()
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func verifyCodeAction(_ sender: UIButton) {
        if loginType == .signup {
            signupAPI()
        } else {
            hitLoginAPI()
        }
    }
    func sendOTPAPI() {
        Loader.spinnerAnimiation(view: self.view)
        let apiRouter = APIRouter.sendOTP(mobile: viewModel.mobile)
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<SendOTPModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success:
                self?.count = 30
                self?.startResendTime()
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    private func hitLoginAPI() {
        Loader.spinnerAnimiation(view: loaderView)
        verifyCodeButton.isHidden = true
        loaderView.isHidden = false
        backButton.isUserInteractionEnabled = false
        let apiRouter = APIRouter.login(phone: viewModel.mobile, otp: otpStackView.getOTP() )
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<LoginModel, CustomError>) in
            Loader.removeLoader()
            self?.rightmarkView.isHidden = false
            self?.backButton.isUserInteractionEnabled = true
            switch response {
            case .success(let result):
                AppUserDefault.setStringValueForKey(key: .userToken, value: result.data?.token?.accessToken ?? "")
                UserDefaults.standard.setValue(result.data?.spotifyToken?.spotifyToken ?? "", forKey: "access_token")
            self?.navigateToHomeVC()
            case .failure(let error):
                self?.rightmarkView.isHidden = true
                self?.loaderView.isHidden = true
                self?.verifyCodeButton.isHidden = false
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    private func signupAPI() {
        Loader.spinnerAnimiation(view: loaderView)
        verifyCodeButton.isHidden = true
        loaderView.isHidden = false
        backButton.isUserInteractionEnabled = false
        let apiRouter = APIRouter.signup(email: viewModel.email, phone: viewModel.mobile, otp: otpStackView.getOTP())
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<LoginModel, CustomError>) in
            Loader.removeLoader()
            self?.backButton.isUserInteractionEnabled = true
            self?.rightmarkView.isHidden = false
            switch response {
            case .success(let result):
                AppUserDefault.setStringValueForKey(key: .userToken, value: result.data?.token?.accessToken ?? "")
                self?.navigateToCompleteYourProfile()
            case .failure(let error):
                self?.rightmarkView.isHidden = true
                self?.loaderView.isHidden = true
                self?.verifyCodeButton.isHidden = false
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    private func navigateToHomeVC() {
        guard let viewController = vcFactory.instatiateHomeVC() else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    private func navigateToCompleteYourProfile() {
        guard let viewController = vcFactory.completeProfileVC() else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// MARK: - OTP Delegate method
extension OTPVarificationVC: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        self.disableContinue = !isValid
        print("is valid \(isValid)")
    }
}

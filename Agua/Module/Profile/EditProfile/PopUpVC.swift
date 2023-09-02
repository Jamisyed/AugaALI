//
//  PopUpVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 15/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import UIKit

class PopUpVC: AGABaseVC {

    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var otpContainerView: UIView!
    @IBOutlet weak var verifyCodeBtn: KTButton!
    @IBOutlet weak var mobileLbl: KTLabel!
    @IBOutlet weak var mobileVarificationView: UIView!
    @IBOutlet weak var emailVarificationView: UIView!
    @IBOutlet weak var submitButton: KTButton!
    @IBOutlet weak var errorLbl: KTLabel!
    @IBOutlet weak var txtField: KTTextField!
    @IBOutlet weak var plusOneStackView: UIStackView!
    @IBOutlet weak var descriptionLbl: KTLabel!
    @IBOutlet weak var emailDescriptionLbl: KTLabel!
    @IBOutlet weak var titleLbl: KTLabel!
    @IBOutlet weak var bottomView: UIView!
    var viewModel = PopUpViewModel()
    let otpStackView = OTPStackView()
    var resendOtpTimer: Timer?
    var count = AGANumericConstants.thirty
    var updateEmailCompletion: ((_ email: String) -> Void)?
    var updateMobileCompletion: ((_ mobile: String) -> Void)?
    var disableContinue: Bool = false {
        didSet {
            if disableContinue {
                verifyCodeBtn.alpha = 0.5
                verifyCodeBtn?.isUserInteractionEnabled = false
            } else {
                verifyCodeBtn.alpha = 1.0
                verifyCodeBtn?.isUserInteractionEnabled = true
            }
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mobileVarificationView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        emailVarificationView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        addGradient(view: mobileVarificationView)
        addGradient(view: bottomView)
        addGradient(view: emailVarificationView)
        emailVarificationView.isHidden = true
        mobileVarificationView.isHidden = true
        bottomView.isHidden = false
        setupOTPContainer()
        startResendTime()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    private func setupOTPContainer() {
            otpContainerView.addSubview(otpStackView)
            otpStackView.delegate = self
            otpStackView.heightAnchor.constraint(equalTo: otpContainerView.heightAnchor).isActive = true
            otpStackView.centerXAnchor.constraint(equalTo: otpContainerView.centerXAnchor).isActive = true
            otpStackView.centerYAnchor.constraint(equalTo: otpContainerView.centerYAnchor).isActive = true
        }
    func uiSetup() {
        titleLbl.text = viewModel.model.title
        descriptionLbl.text = viewModel.model.description
        let screenType = viewModel.model.updateField
        switch screenType {
        case .email:
            setupForEmailTextField()
        case .mobile:
            setupForMobileTextField()
        }
    }
    private func setupForEmailTextField() {
        plusOneStackView.isHidden = true
        txtField.keyboardType = .emailAddress
        txtField.placeholder = "Email"
        submitButton.setTitle("Submit", for: .normal)
    }
    private func setupForMobileTextField() {
        plusOneStackView.isHidden = false
        txtField.keyboardType = .decimalPad
        txtField.placeholder = "Phone Number"
        txtField.padding = 60
        submitButton.setTitle("Continue", for: .normal)
    }
    @IBAction func gotItAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func resendCodeAction(_ sender: UIButton) {
        sendOTPAPI(isResendCodeApi: true)
    }
    @IBAction func verifyCodeAction(_ sender: KTButton) {
        sendOTPAPI(isResendCodeApi: false)
    }
    @IBAction func mobileVarificationBackAction(_ sender: UIButton) {
        mobileVarificationView.isHidden = true
    }
    @IBAction func saveChangesAction(_ sender: KTButton) {
        let screenType = viewModel.model.updateField
        switch screenType {
        case .email: apiHandlingForEmailChange()
        case .mobile: apiHandlingForMobileChange()
        }
    }
    func apiHandlingForEmailChange() {
        if !viewModel.validateEmail() {
            errorLbl.text = AGAStringConstants.Validations.invalidEmail
            return
        }
        // here need to hit update email api
        apiForEmailUpdate()
    }
    func apiForEmailUpdate() {
        Loader.spinnerAnimiation(view: self.view)
        let apiRouter = APIRouter.changeEmail(email: viewModel.model.text)
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<BookMarkSongsListModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success:
                DispatchQueue.main.async {
                    self?.showUpdateEmailConfirmationUI()
                }
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    func apiHandlingForMobileChange() {

        if !viewModel.validateMobile() {
            errorLbl.text = AGAStringConstants.Validations.invalidMobile
            return
        }
        // hit send OTP API
        sendOTPAPI(isResendCodeApi: true)
    }
    func sendOTPAPI(isResendCodeApi: Bool) {
        let otp = isResendCodeApi ? "" : otpStackView.getOTP()
        let apiRouter = APIRouter.changeMobile(mobile: viewModel.model.text, otp: otp)
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<SendOTPModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success:
                if isResendCodeApi {
                self?.showUIToEnterOTP()
                } else {
                    self?.updateMobileCompletion?(self?.viewModel.model.text ?? "")
                    self?.dismiss(animated: false, completion: nil)
                }
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    func showUIToEnterOTP() {
        self.otpStackView.clearOtp()
        mobileLbl.text = "+1" + viewModel.model.text
        bottomView.isHidden = true
        emailVarificationView.isHidden = true
        mobileVarificationView.isHidden = false
    }
    func showUpdateEmailConfirmationUI() {
        updateEmailCompletion?(viewModel.model.text)
        bottomView.isHidden = true
        mobileVarificationView.isHidden = true
        emailVarificationView.isHidden = false
        let emailCount = viewModel.model.text.count
        let attributedString = NSMutableAttributedString(string: "We have sent email verification to \(viewModel.model.text). Please click link on the email address to confirm.", attributes: [
            .font: UIFont(name: AGAFont.Lexend.kRegular, size: 16*screenScaleFactor)!,
          .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
          .kern: 0.3
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor.greenColor,
                                      range: NSRange(location: 35, length: emailCount))
        emailDescriptionLbl.attributedText = attributedString
    }
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
extension PopUpVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderWidth = 0
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderColor = UIColor.greenColor
        textField.borderWidth = 1
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == " " { return false }
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let screenType = viewModel.model.updateField
        switch screenType {
        case .email:
            if updatedString?.count ?? 0 > AGANumericConstants.sixtyFour { return false}
            viewModel.model.text = updatedString ?? ""
            errorLbl.text = ""
        case .mobile:
            if string == "." { return false }
            if updatedString?.count ?? 0 > AGANumericConstants.k12 { return false}
            viewModel.model.text = updatedString ?? ""
            errorLbl.text = ""
        }
        return true
    }
}
// MARK: - OTP Delegate method
extension PopUpVC: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        self.disableContinue = !isValid
        print("is valid \(isValid)")
    }
}

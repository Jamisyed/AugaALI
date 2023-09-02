//
//  AGASignUpVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 23/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import UIKit

class AGASignUpVC: AGABaseVC {
let viewModel = SignUpViewModel()
    @IBOutlet weak var tblView: UITableView!
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: SignTableViewCell.identifire, bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: SignTableViewCell.identifire)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGradientBackground()
    }

}
// MARK: - UITableView delegate and datasource

extension AGASignUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: SignTableViewCell.identifire,
                                     for: indexPath) as? SignTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell(isTickMarkChecked: viewModel.isCheckMarkSelected,
                           emailErrorMessage: viewModel.emailErrorMessage,
                           mobileErrorMessage: viewModel.mobileErrorMessage)
        return cell
    }
}

// MARK: - TableCell Delegate methods

extension AGASignUpVC: SignUpProtocol {
    func crossButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldBeginEditiong(textFieldType: SignUpTextFieldType) {
    }
    func textFieldChangeEditing(textFieldType: SignUpTextFieldType, text: String) {
        switch textFieldType {
        case .email:
            viewModel.email = text
            viewModel.emailErrorMessage = ""
        case .mobile:
            viewModel.mobile = text
            viewModel.mobileErrorMessage = ""
        default: break
        }
    }
    func checkMarkAction(isSelected: Bool) {
        viewModel.isCheckMarkSelected = isSelected
    }
    // continue button handling
    func validationData(tuple: (SignUpTextFieldType, SignUpTextFieldType)) {
        switch tuple.0 {
        case .email(let error):
            viewModel.emailErrorMessage = error
        default: break
        }
        switch tuple.1 {
        case .mobile(let error):
            viewModel.mobileErrorMessage = error
        default: break
        }
        if !viewModel.emailErrorMessage.isEmpty || !viewModel.mobileErrorMessage.isEmpty {
            reloadTableView()
            return
        } else {
            if !viewModel.isCheckMarkSelected {
                showPopNotificationView(
                    notiMessage: AGAStringConstants.Validations.termsOfSercice, notificationType: .error)
                return
            }
            self.signUpAPI()
        }
    }
    func signUpAPI() {
        Loader.spinnerAnimiation(view: self.view)
        let apiRouter = APIRouter.signup(email: viewModel.email, phone: viewModel.mobile, otp: "")
        viewModel.callAPI(route: apiRouter) {[weak self] (response: Swift.Result<LoginModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success:
                DispatchQueue.main.async {
                    self?.navigateToOTPScreen()
                }
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    func navigateToOTPScreen() {
        if let otpVC = vcFactory.instatiateOTP() {
            otpVC.viewModel.email = viewModel.email
            otpVC.viewModel.mobile = viewModel.mobile
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
    func termsOfServiceClicked() {
        // open terms and condtion screen
        if let termsAndCondition = vcFactory.webKitVC() {
            termsAndCondition.urlStr = URLConstant.tersAndConditon
            self.present(termsAndCondition, animated: true, completion: nil)
        }
    }
}

// MARK: - Supporting methods

extension AGASignUpVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}

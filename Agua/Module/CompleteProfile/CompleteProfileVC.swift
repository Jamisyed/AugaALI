//
//  CompleteProfileVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 26/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import UIKit

class CompleteProfileVC: AGABaseVC {
    @IBOutlet weak var profilePicBg: UIView!
    @IBOutlet weak var usernameErrorLbl: KTLabel!
    var imagePicker: ImagePicker!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var completeProfileTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var enterNameTxtField: KTTextField!
    var viewModel = CompleteProfileViewModel()
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        completeProfileTopConstraints.constant = 110/screenScaleFactor
        // Do any additional setup after loading the view.
    }
    @IBAction func uploadImageAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.imagePicker.present(from: sender, showRemovePicOption: false)
    }
    @IBAction func doItLaterAction(_ sender: UIButton) {
        navigateToHomeVC()
    }
    private func navigateToHomeVC() {
        if let homeVC = vcFactory.instatiateHomeVC() {
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    @IBAction func continueAction(_ sender: UIButton) {
        if viewModel.validateIfUserNameIsEmpty() {
            usernameErrorLbl.text = AGAStringConstants.Validations.enterName
            return
        }
        if viewModel.validateIfProfilePicIsEmpty() {
            showPopNotificationView(notiMessage: AGAStringConstants.Validations.selectImage, notificationType: .error)
            return
        }
        completeYourProfileAPI()
    }
    private func completeYourProfileAPI() {
        if let image = viewModel.image?.pngData() {
            Loader.spinnerAnimiation(view: self.view)
            let key = ParameterKey.profilePicture
            let imageDic = ImageDic(data: image, key: key)
            let apiRouter = APIRouter.completeProfile(userName: viewModel.userName, isPicRemove: false)
            viewModel.completeYourProfile(
                route: apiRouter,
                imageDic: [imageDic]) {[weak self] (response: Swift.Result<CompleteProfileModel, CustomError>) in
                Loader.removeLoader()
                switch response {
                case .success(let result):
                    debugPrint(result)
                    self?.navigateToHomeVC()
                case .failure(let error):
                    self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
                }
            }
        }
    }
}
extension CompleteProfileVC: ImagePickerDelegate {
    func removePic() {
    }

    func didSelect(image: UIImage?) {
        if let image = image {
            viewModel.image = image
            self.profileImgView.image = image
        }
    }
}

// MARK: - UITextField delegate methods

extension CompleteProfileVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return false
            }
        } catch {
            print("ERROR")
        }
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        viewModel.userName = updatedString ?? ""
        usernameErrorLbl.text = ""
        return true
    }
}

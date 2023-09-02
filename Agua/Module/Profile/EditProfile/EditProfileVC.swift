//
//  EditProfileVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 14/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import UIKit

class EditProfileVC: AGABaseVC {
   let viewModel = EditProfileViewModel()
    @IBOutlet weak var tblView: UITableView!
    var imagePicker: ImagePicker!
    var headerView: ProfilePicHeaderView?
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    var vcDismissedCompletion: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        viewModel.createDataSource()
        registerTableCellAndHeader()
        addGradient(view: self.view)
        let profilePic = viewModel.userProfile?.data?.profile ?? ""
        if profilePic.isEmpty {
            viewModel.isRemovePicOption = false
        } else {
            viewModel.isRemovePicOption = true
        }
        // Do any additional setup after loading the view.
    }
    deinit {
        vcDismissedCompletion?()
        debugPrint("View dismissed")
    }
    func registerTableCellAndHeader() {
        let nib = UINib(nibName: ProfilePicHeaderView.identifire, bundle: nil)
        tblView.register(nib, forHeaderFooterViewReuseIdentifier: ProfilePicHeaderView.identifire)
        let cellNib = UINib(nibName: InputTextFieldCell.identifire, bundle: nil)
        tblView.register(cellNib, forCellReuseIdentifier: InputTextFieldCell.identifire)
    }
    @IBAction func saveChanges(_ sender: KTButton) {
        if viewModel.validateIfUserNameIsEmpty() {
            let textFielType = SignUpTextFieldType.userName(validationError: AGAStringConstants.Validations.enterName)
            viewModel.dataSource[0].fieldType = textFielType
            reloadTableView()
            return
        }
        self.view.endEditing(true)
        completeYourProfileAPI(removePic: !viewModel.isRemovePicOption)
    }
    @IBAction func doneAction(_ sender: KTButton) {
        vcDismissedCompletion?()
        self.dismiss(animated: true, completion: nil)
    }
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    private func completeYourProfileAPI(removePic: Bool) {
        let image = viewModel.image?.pngData() ?? Data()
        Loader.spinnerAnimiation(view: self.view)
        let key = ParameterKey.profilePicture
        let imageDic = ImageDic(data: image, key: key)
        let userName = viewModel.dataSource.first?.text ?? ""
        let apiRouter = APIRouter.completeProfile(userName: userName, isPicRemove: removePic)
        viewModel.completeYourProfile(
            route: apiRouter,
            imageDic: [imageDic]) {[weak self] (response: Swift.Result<CompleteProfileModel, CustomError>) in
                Loader.removeLoader()
                switch response {
                case .success(let result):
                    debugPrint(result)
                    self?.viewModel.isRemovePicOption = removePic ? false : true
                    if removePic {
                        self?.headerView?.profileImgView.image = #imageLiteral(resourceName: "profilePlaceholder.pdf")
                    }
                case .failure(let error):
                    self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
                }
            }
    }

}

extension EditProfileVC: ImagePickerDelegate {
    func removePic() {
        completeYourProfileAPI(removePic: true)
    }
    func didSelect(image: UIImage?) {
        if let image = image {
            viewModel.isRemovePicOption = true
            viewModel.image = image
            headerView?.profileImgView.image = image
        }
    }
}
extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.dataSource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InputTextFieldCell.identifire, for: indexPath) as? InputTextFieldCell else { return UITableViewCell() }
        cell.delegate = self
        let record = viewModel.dataSource[indexPath.row]
        cell.configureCell(model: record)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ProfilePicHeaderView.identifire) as? ProfilePicHeaderView {
            self.headerView = headerView
            headerView.editPicButtonCompletion = {[weak self] in
                self?.imagePicker.present(from: headerView, showRemovePicOption: self?.viewModel.isRemovePicOption ?? false)
            }
            if let imgStr = viewModel.userProfile?.data?.profile {
                headerView.configureCell(imageStr: imgStr)
            }
            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        210
    }
}

extension EditProfileVC: InputTextFieldProtocol {
    func textFieldBeginEditiong(textFieldType: SignUpTextFieldType) {
    }
    func textFieldChangeEditing(textFieldType: SignUpTextFieldType, text: String) {
        viewModel.dataSource[0].text = text
    }
    func changeData(textFieldType: SignUpTextFieldType) {
        switch textFieldType {
        case .userName: break
        case .email: displayPopup(textFieldType: .email(validationError: ""))
        case .mobile: displayPopup(textFieldType: .mobile(validationError: ""))
        }
    }
    func displayPopup(textFieldType: SignUpTextFieldType) {
        guard let popupVC = vcFactory.popupVC() else { return }
        switch textFieldType {
        case .userName: break
        case .email:
            let model = PopUpModel(updateField: .email,
                                   title: "Change Email Address",
                                   description: "Enter your email and we will send a confirmation mail to verify",
                                   text: "",
                                   error: "")
            popupVC.viewModel.model = model
        case .mobile:
            let model = PopUpModel(updateField: .mobile,
                                   title: "Change Phone Number",
                                   description: "Enter your phone number and we will send a verification code for confirmation",
                                   text: "",
                                   error: "")
            popupVC.viewModel.model = model
        }
        popupVC.updateEmailCompletion = {[weak self] email in
            self?.viewModel.dataSource[1].text = email
            self?.reloadTableView()
        }
        popupVC.updateMobileCompletion = {[weak self] mobile in
            self?.viewModel.dataSource[2].text = mobile
            self?.reloadTableView()
        }
        let nav = UINavigationController(rootViewController: popupVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
}

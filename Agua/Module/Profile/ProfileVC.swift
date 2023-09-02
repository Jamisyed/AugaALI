//
//  ProfileVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 01/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import UIKit

class ProfileVC: AGABaseVC {
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    let viewModel = ProfileViewModel()
    var imagePicker: ImagePicker!
    var headerView: ProfileHeaderView?
    var isNameAvailable = false
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        setGradientBackground()
        registerTableCellAndHeader()
        viewModel.createDataSource()
        getUserProfile()
        // Do any additional setup after loading the view.
    }
    func registerTableCellAndHeader() {
        let nib = UINib(nibName: ProfileHeaderView.identifire, bundle: nil)
        tblView.register(nib, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifire)
        let cellNib = UINib(nibName: ProfileCell.identifire, bundle: nil)
        tblView.register(cellNib, forCellReuseIdentifier: ProfileCell.identifire)
    }
}

extension ProfileVC {
    func getUserProfile() {
        Loader.removeLoader()
        let apiRouter = APIRouter.getUserProfile
       // Loader.spinnerAnimiation(view: self.view)
        viewModel.callAPI(route: apiRouter) {[weak self] (response: Swift.Result<UserProfile, CustomError>) in
           // Loader.removeLoader()
            switch response {
            case .success(let result):
                self?.viewModel.userProfile = result
                self?.showProfileImage(imageStr: result.data?.profile ?? "",
                                       email: result.data?.email ?? "", name: result.data?.userName ?? "")
                self?.tblView.reloadData()
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    private func showProfileImage(imageStr: String, email: String, name: String) {
        guard let objHeader = self.tblView.headerView(forSection: 0) as? ProfileHeaderView else { return }
        headerView = objHeader
        objHeader.emailLbl.text = email
        objHeader.nameLbl.text = name
        objHeader.nameLbl.isHidden = name == ""
        isNameAvailable = !objHeader.nameLbl.isHidden
       // Loader.spinnerAnimiation(view: objHeader.profileImgView)
        DispatchQueue.global().async {
            do {
                guard let url = URL(string: imageStr) else {
                    Loader.removeLoader()
                    DispatchQueue.main.async {
                        self.headerView?.uploadPicButton.isUserInteractionEnabled = true
                    }
                    self.viewModel.showRemovePicOption = false
                    return
                }
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let headerView = self.tblView.headerView(forSection: 0) as? ProfileHeaderView {
                        DispatchQueue.main.async {
                            headerView.uploadPicButton.isUserInteractionEnabled = true
                        }
                        self.viewModel.showRemovePicOption = true
                        Loader.removeLoader()
                        headerView.profileImgView.image = UIImage(data: data)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.headerView?.uploadPicButton.isUserInteractionEnabled = true
                }
                self.viewModel.showRemovePicOption = false
                Loader.removeLoader()
                debugPrint(error)
            }
        }
    }
}

// MARK: - UITableView delegate and datasource
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifire,
                                                       for: indexPath) as? ProfileCell else { return UITableViewCell() }
        cell.configureCell(cellType: viewModel.dataSource[indexPath.row].cellType)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ProfileHeaderView.identifire) as? ProfileHeaderView {
            headerView.backButtonCompletion = {[weak self] in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            headerView.editButtonCompletion = {[weak self] in
                self?.navigateToEditProfile()
            }
            headerView.updatePicButtonCompletion = {[weak self] in
                DispatchQueue.main.async {
                    self?.imagePicker.present(from: headerView,
                                              showRemovePicOption: self?.viewModel.showRemovePicOption ?? false)
                }
            }
            return headerView
        }
        return nil
    }
    private func navigateToEditProfile() {
        guard let editProfileVC = vcFactory.editProfileVC() else { return }
        editProfileVC.vcDismissedCompletion = {[weak self] in
            self?.getUserProfile()
        }
        editProfileVC.viewModel.userProfile = viewModel.userProfile
        let nav = UINavigationController(rootViewController: editProfileVC)
        self.present(nav, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = viewModel.dataSource[indexPath.row].cellType
        if cellType == .logout {
            callLogOutAndDeleteAPI()
        }
        if cellType == .deleteAccount {
            deleteAccount()
        }
        if cellType == .connectAccounts {
            guard let viewController = vcFactory.linkedAccountsVC() else {
                return
            }
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true, completion: nil)
        }
        if cellType == .termsAndCondition {
            navigateToWebView(urlStr: URLConstant.tersAndConditon)
        }
        if cellType == .howToUse {
            navigateToWebView(urlStr: URLConstant.howToUse)
        }
        if cellType == .privacy {
            navigateToWebView(urlStr: URLConstant.privacyPolicy)
        }
        if cellType == .playAdv {
            guard let viewController = vcFactory.playAdv() else {
                return
            }
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true, completion: nil)
        }
        if cellType == .bookmark {
            guard let bookmarkVC = vcFactory.bookmarkListVC() else { return }
            self.present(bookmarkVC, animated: true, completion: nil)
        }
    }
    private func deleteAccount() {
        let alert = UIAlertController(title: AGAStringConstants.AlertConst.deleteAccount,
                                      message: AGAStringConstants.AlertConst.deleteAccountDesc, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: AGAStringConstants.AlertConst.delete,
                                         style: .destructive, handler: { (_) in
            self.callLogOutAndDeleteAPI(isDeleteAccount: true)

        })
        alert.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: AGAStringConstants.AlertConst.cancel, style: .cancel)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
    func callLogOutAndDeleteAPI(isDeleteAccount: Bool = false) {
        let apiRouter =  isDeleteAccount ? APIRouter.deleteAccount : APIRouter.logout
        Loader.spinnerAnimiation(view: self.view)
        viewModel.callAPI(route: apiRouter) {[weak self] (response: Swift.Result<LogOutModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success:
                DispatchQueue.main.async {
                    self?.navigateToLoginScreen()
                }
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    private func navigateToLoginScreen() {
        if let welcomeVC = vcFactory.welcomeVC() {
            AppUserDefault.removeValueForKey(key: .userToken)
            AppUserDefault.removeValueForKey(key: .accessToken)
            let window = UIApplication.shared.windows.first
            let nav = UINavigationController(rootViewController: welcomeVC)
            window?.rootViewController = nav
        }
    }
    func navigateToWebView(urlStr: String) {
        if let termsAndCondition = vcFactory.webKitVC() {
            termsAndCondition.urlStr = urlStr
            self.present(termsAndCondition, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return !isNameAvailable ? 355 : 375
    }
}
extension ProfileVC: ImagePickerDelegate {
    func removePic() {
        updateProfilePicOnServer(isPicRemove: true)
    }
    func didSelect(image: UIImage?) {
        if let image = image {
            viewModel.image = image
            headerView?.profileImgView.image = image
            updateProfilePicOnServer(isPicRemove: false)
        }
    }
    func updateProfilePicOnServer(isPicRemove: Bool) {
        let image = viewModel.image?.pngData() ?? Data()
        Loader.spinnerAnimiation(view: self.view)
        let key = ParameterKey.profilePicture
        let imageDic = ImageDic(data: image, key: key)
        let apiRouter = APIRouter.completeProfile(
            userName: viewModel.userProfile?.data?.userName ?? "", isPicRemove: isPicRemove)
        viewModel.updateProfilePic(
            route: apiRouter,
            imageDic: [imageDic]) {[weak self] (response: Swift.Result<CompleteProfileModel, CustomError>) in
                Loader.removeLoader()
                switch response {
                case .success(let result):
                    debugPrint(result)
                    if isPicRemove {
                        self?.viewModel.showRemovePicOption = false
                        self?.headerView?.profileImgView.image  = #imageLiteral(resourceName: "profilePlaceholder.pdf")
                        self?.viewModel.userProfile?.data?.profile = ""
                    } else {
                        self?.viewModel.showRemovePicOption = true
                        self?.viewModel.userProfile?.data?.profile = result.data?.profilePicture
                    }
                case .failure(let error):
                    self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
                }
            }
    }
}

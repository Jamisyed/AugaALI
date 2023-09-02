//
//  ConnectedAccountsVC.swift
//  Agua
//
//  Created by Muneesh Kumar on 02/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import UIKit

class ConnectedAccountsVC: AGABaseVC {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tblView: UITableView!
    let viewModel = ConnectedAccountsViewModel()
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.createDataSource()
        let cellNib = UINib(nibName: ProfileCell.identifire, bundle: nil)
        tblView.register(cellNib, forCellReuseIdentifier: ProfileCell.identifire)
        // MARK: Remove Spotify ans Amazon Account integration
//        if AuthManager.shared.isSignIn {
//            viewModel.dataSource[0].connctedState = true
//        } else {
//            viewModel.dataSource[0].connctedState = false
//        }
        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func yesBtnAction(_ sender: Any) {
        viewModel.dataSource[0].connctedState = false
        AuthManager.shared.logout()
        bottomView.isHidden = true
        reloadtableView()
        saveSpotifyTokenAtServer()
    }
    @IBAction func noBtnAction(_ sender: KTButton) {
        bottomView.isHidden = true
    }
}
extension ConnectedAccountsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifire,
                                                       for: indexPath) as? ProfileCell else { return UITableViewCell() }
        cell.connectButtonCompletion = {[weak self] selectedRow in
            if selectedRow == 0 {
                //MARK:  Remove Connect Action 
          //  self?.handleConnectButton()
            }
        }
        cell.configureCellForConnectedAccounts(
            cellType: viewModel.dataSource[indexPath.row].cellType,
            connectedStatus: viewModel.dataSource[indexPath.row].connctedState, selectedRow: indexPath.row)
        cell.switchButton.isHidden = true
        if indexPath.row == 0 {
            cell.imgView.alpha = 0.5
            cell.titleLbl.alpha = 0.5
            cell.connectButton.alpha = 0.5
        } else {
            cell.imgView.alpha = 1
            cell.titleLbl.alpha = 1
            cell.connectButton.alpha = 1
        }
        return cell
    }
    func handleConnectButton() {
        if !AuthManager.shared.isSignIn {
            if let spotyfyVC = vcFactory.spotifyWebView() {
                spotyfyVC.completionHandlar = {[weak self]  status in
                    if status {
                        self?.viewModel.dataSource[0].connctedState = true
                        self?.reloadtableView()
                        self?.saveSpotifyTokenAtServer()
                    }
                    print("Status \(status)")
                }
                self.navigationController?.pushViewController(spotyfyVC, animated: true)
            }
        } else {
            bottomView.isHidden = false
        }
    }
    func reloadtableView() {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}
// MARK: - Save spotify token at server
extension ConnectedAccountsVC {
    func saveSpotifyTokenAtServer() {
        DispatchQueue.main.async {
            Loader.spinnerAnimiation(view: self.view)
        }
        let apiRouter = APIRouter.saveSpotifyToken
        viewModel.saveSpotifyToken(route: apiRouter) { (response: Swift.Result<SaveSpotifyTokenModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success: break
            case .failure: break
            }
        }
    }
}

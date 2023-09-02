//
//  ProfileHeaderView.swift
//  Agua
//
//  Created by Muneesh Kumar on 02/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView, Identifiable {

    @IBOutlet weak var uploadPicButton: UIButton!
    @IBOutlet weak var emailLbl: KTLabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    var backButtonCompletion: (() -> Void)?
    var editButtonCompletion: (() -> Void)?
    var updatePicButtonCompletion: (() -> Void)?
    @IBAction func backBtnAction(_ sender: UIButton) {
        backButtonCompletion?()
    }
    @IBAction func editProfileTapped(_ sender: KTButton) {
        editButtonCompletion?()
    }
    @IBAction func updatePicAction(_ sender: UIButton) {
        updatePicButtonCompletion?()
    }
}

//
//  ProfilePicHeaderView.swift
//  Agua
//
//  Created by Muneesh Kumar on 14/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import UIKit

class ProfilePicHeaderView: UITableViewHeaderFooterView, Identifiable {
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImgView: UIImageView!
    var editPicButtonCompletion: (() -> Void)?
    @IBAction func editPhotoAction(_ sender: UIButton) {
        editPicButtonCompletion?()
    }
    func configureCell(imageStr: String) {
        Loader.spinnerAnimiation(view: profileImgView)
        DispatchQueue.global().async {
            do {
                guard let url = URL(string: imageStr) else {
                    DispatchQueue.main.async {
                        self.editButton.isUserInteractionEnabled = true
                    }
                    Loader.removeLoader()
                    return
                }
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    Loader.removeLoader()
                    self.editButton.isUserInteractionEnabled = true
                    self.profileImgView.image = UIImage(data: data)
                }
            } catch {
                Loader.removeLoader()
                DispatchQueue.main.async {
                self.editButton.isUserInteractionEnabled = true
                }
                debugPrint(error)
            }
        }
    }
}

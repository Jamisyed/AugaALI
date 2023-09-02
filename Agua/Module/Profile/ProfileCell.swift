//
//  ProfileCell.swift
//  Agua
//
//  Created by Muneesh Kumar on 02/02/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell, Identifiable {

    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var connectButton: KTButton!
    @IBOutlet weak var blueArrowImgView: UIImageView!
    @IBOutlet weak var titleLbl: KTLabel!
    @IBOutlet weak var imgView: UIImageView!
    var connectButtonCompletion: ((_ selectedRow: Int) -> Void)?
    var selectedRow = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(cellType: ProfileCellType) {
        connectButton.isHidden = true
        titleLbl.text = cellType.rawValue.description
        imgView.image = cellType.image
        if cellType == .playAdv {
            switchButton.isHidden = false
            if AdvertisementHandlar.shared.switchState {
                switchButton.setOn(true, animated: true)
            } else {
                switchButton.setOn(false, animated: true)
            }
        } else {
            switchButton.isHidden = true
        }
    }
    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn {
            AdvertisementHandlar.shared.stopTimer()
            AdvertisementHandlar.shared.switchState = true
        } else {
            AdvertisementHandlar.shared.updateTimer()
            AdvertisementHandlar.shared.switchState = false
        }
    }
    func configureCellForConnectedAccounts(cellType: ProfileCellType, connectedStatus: Bool, selectedRow: Int) {
        blueArrowImgView.isHidden = true
        self.selectedRow = selectedRow
        titleLbl.text = cellType.rawValue.description
        imgView.image = cellType.image
        if connectedStatus {
            connectButton.setTitleColor(UIColor.disconnectColor, for: .normal)
            connectButton.setTitle("Disconnect", for: .normal)
        } else {
            connectButton.setTitleColor(UIColor.connectColor, for: .normal)
            connectButton.setTitle("Connect", for: .normal)
        }
    }
    @IBAction func connectAction(_ sender: KTButton) {
        if self.selectedRow == 0 {
            connectButtonCompletion?(selectedRow)
        }
    }
}

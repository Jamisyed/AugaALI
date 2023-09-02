//
//  AGASongTableViewCell.swift
//  Agua
//
//  Created by vikash singh on 9/29/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import UIKit
class AGASongTableViewCell: UITableViewCell, Identifiable {
    @IBOutlet weak var textLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var bannerImageWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var bookMarkBtn: UIButton!
    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var bannerImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellForSongs(result: Result) {
        bannerImageWidthConstraints.constant = CGFloat(AGANumericConstants.k38)
        textLeadingConstraints.constant = CGFloat(AGANumericConstants.ten)
        artistNameLbl.text = result.artists?.first?.name ?? ""
        songNameLbl.text = result.title ?? ""
        let image = result.bookmark?.isSubscribed ?? false ? #imageLiteral(resourceName: "selectedBookmark.pdf"): #imageLiteral(resourceName: "unSelectedBookmark.pdf")
        bookMarkBtn.setImage(image, for: .normal)
        bannerImg.image = UIImage(named: "songsPlaceholder")
    }
    func configureCellForProducts(result: Product) {
        artistNameLbl.text = result.name
        songNameLbl.text = result.brand?.name
        bannerImageWidthConstraints.constant = 0
        textLeadingConstraints.constant = 0
    }
}

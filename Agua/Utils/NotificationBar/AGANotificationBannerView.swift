import UIKit
class AGANotificationBannerView: UIView, Identifiable {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var alertString: UILabel!
    class func instanceFromNib() -> UIView {
        return UINib(nibName: AGANotificationBannerView.identifire,
                     bundle: nil).instantiate(withOwner: nil,
                    options: nil)[0] as? UIView ?? UIView()
    }
}

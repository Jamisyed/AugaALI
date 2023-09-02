import UIKit

class LoadingMoreView: UIView, NibLoadableView {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.startAnimating()
    }
}

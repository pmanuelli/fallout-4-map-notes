import UIKit

class MapView: UIView {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mapImageView: UIImageView!
    
    override func awakeFromNib() {
        
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 3
        
        mapImageView.isUserInteractionEnabled = true
    }
}

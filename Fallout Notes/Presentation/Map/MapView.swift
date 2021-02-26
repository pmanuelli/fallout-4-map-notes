import UIKit

class MapView: UIView {
    
    @IBOutlet var mapScrollView: UIScrollView!
    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var createLocationButton: UIButton!
    @IBOutlet var createLocationButtonContainer: UIView!
    @IBOutlet var createLocationMessageContainer: UIView!
    
    var mapZoomScale: CGFloat { mapScrollView.zoomScale }
    
    override func awakeFromNib() {
        
        mapScrollView.minimumZoomScale = 0.5
        mapScrollView.maximumZoomScale = 3
        
        mapImageView.isUserInteractionEnabled = true
        
        createLocationMessageContainer.alpha = 0
    }
    
    func showCreateLocationButton() {
        UIView.animate(withDuration: 0.2) {
            self.createLocationButtonContainer.alpha = 1
        }
    }
    
    func hideCreateLocationButton() {
        UIView.animate(withDuration: 0.2) {
            self.createLocationButtonContainer.alpha = 0
        }
    }
    
    func showAndHideCreateLocationMessageAnimated() {
        
        UIView.animate(withDuration: 0.2) {
            self.createLocationMessageContainer.alpha = 1
        } completion: { _ in
            
            UIView.animate(withDuration: 0.2, delay: 5) {
                self.createLocationMessageContainer.alpha = 0
            }
        }
    }
}

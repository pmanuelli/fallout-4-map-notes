import UIKit

class DisclosureIndicatorImageViewFactory {
    
    static func create() -> UIImageView {
        
        let size = CGSize(width: 16, height: 16)
        
        let imageView = GreenBlurImageView(frame: CGRect(origin: .zero, size: size))
        imageView.image = UIImage(named: "disclosure_indicator")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
}

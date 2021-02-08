import UIKit

struct GreenBlurEffect {
    
    static func apply(to imageView: UIImageView) {
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.greenDark
        apply(to: imageView as UIView)
    }
    
    static func apply(to label: UILabel) {
        label.textColor = Colors.greenDark
        apply(to: label as UIView)
    }
    
    static private func apply(to view: UIView) {
        view.clipsToBounds = false
        view.layerShadowColor = Colors.greenLight
        view.layerShadowRadius = 3
        view.layerShadowOpacity = 0.75
        view.layerShadowOffset = .zero
    }
}

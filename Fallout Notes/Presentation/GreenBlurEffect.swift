import UIKit

struct GreenBlurEffect {
    
    static func apply(on imageView: UIImageView) {
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.greenDark
        apply(on: imageView as UIView)
    }
    
    static func apply(on label: UILabel) {
        label.textColor = Colors.greenDark
        apply(on: label as UIView)
    }
    
    static private func apply(on view: UIView) {
        view.clipsToBounds = false
        view.layerShadowColor = Colors.greenLight
        view.layerShadowRadius = 3
        view.layerShadowOpacity = 0.75
        view.layerShadowOffset = .zero
    }
}

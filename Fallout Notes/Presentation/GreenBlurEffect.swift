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
    
    static func apply(to switch: UISwitch) {
        `switch`.onTintColor = Colors.greenDark
        apply(to: `switch` as UIView)
    }
    
    static func apply(to view: UIView) {
        view.clipsToBounds = false
        view.layerShadowColor = Colors.greenLight
        view.layerShadowRadius = 3
        view.layerShadowOpacity = 0.75
        view.layerShadowOffset = .zero
    }
    
    static func remove(from view: UIView) {
        view.layerShadowColor = nil
        view.layerShadowRadius = 0
        view.layerShadowOpacity = 0
        view.layerShadowOffset = .zero
    }
}

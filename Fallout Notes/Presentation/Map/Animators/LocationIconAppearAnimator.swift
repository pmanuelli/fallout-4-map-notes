import UIKit

struct LocationIconAppearAnimator {

    enum Origin {
        case center
        case bottom
    }
    
    static func animate(_ view: UIView, origin: Origin = .center, completion: (() -> Void)? = nil) {
        
        setViewAnchorPoint(view, origin: origin)
        
        let originalTransform = view.transform
        
        view.transform = .scale(0.01)
        view.alpha = 0
        
        let animations = {
            view.transform = originalTransform
            view.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 2, options: [],
                       animations: animations,
                       completion: { _ in completion?() })
    }
    
    private static func setViewAnchorPoint(_ view: UIView, origin: Origin) {

        switch origin {
        case .center:
            view.setLayerAnchorPoint(CGPoint(x: 0.5, y: 0.5))
        case .bottom:
            view.setLayerAnchorPoint(CGPoint(x: 0.5, y: 1))
        }
    }
}

extension UIView {
    
    var layerAnchorPoint: CGPoint {
        get { layer.anchorPoint }
        set { setLayerAnchorPoint(newValue) }
    }
    
    func setLayerAnchorPoint(_ value: CGPoint) {
        let frame = self.frame
        layer.anchorPoint = value
        self.frame = frame
    }
}

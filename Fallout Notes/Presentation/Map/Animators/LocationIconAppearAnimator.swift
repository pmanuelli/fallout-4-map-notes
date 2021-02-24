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
                
        let frame = view.frame
        
        switch origin {
        case .center:
            view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        case .bottom:
            view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        }
        
        view.frame = frame
    }
}

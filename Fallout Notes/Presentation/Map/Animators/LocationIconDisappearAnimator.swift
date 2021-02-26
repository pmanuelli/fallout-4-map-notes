import UIKit

struct LocationIconDisappearAnimator {
    
    enum Origin {
        case center
        case bottom
    }
    
    static func animate(_ view: UIView, origin: Origin = .center, scaling: Bool = true, completion: (() -> Void)?) {
        
        setViewAnchorPoint(view, origin: origin)
                        
        let animations = {
            if scaling { view.transform = .scale(0.01) }
            view.alpha = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: animations,
                       completion: { _ in
                        
                        view.transform = .identity
                        completion?() })
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

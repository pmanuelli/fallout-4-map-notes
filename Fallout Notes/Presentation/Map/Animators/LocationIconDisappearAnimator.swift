import UIKit

struct LocationIconDisappearAnimator {
    
    enum Origin {
        case center
        case bottom
    }
    
    static func animate(_ view: UIView, origin: Origin = .center, scaling: Bool = true, completion: (() -> Void)?) {
        
        let frame = view.frame
        
        switch origin {
        case .center:
            view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        case .bottom:
            view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        }
        
        view.frame = frame
                        
        let animations = {
            if scaling { view.transform = .scale(0.01) }
            view.alpha = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: animations,
                       completion: { _ in
                        
                        view.transform = .identity
                        completion?() })
    }
}

import UIKit

struct DroppedPinDisappearAnimator {

    static func animate(_ view: UIView, completion: (() -> Void)?) {
        
        let frame = view.frame
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        view.frame = frame
                
        let animations = {
            view.transform = .scale(0.01)
            view.alpha = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: animations, completion: { _ in completion?() })
    }
}

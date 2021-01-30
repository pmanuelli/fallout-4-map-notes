import UIKit

struct LocationViewAppearAnimator {

    static func animate(_ view: UIView, completion: (() -> Void)?) {
                
        view.transform = .scale(0)
        view.alpha = 0
        
        let animations = {
            view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            view.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 2, options: [],
                       animations: animations,
                       completion: { _ in completion?() })
    }
}

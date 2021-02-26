import UIKit
import iOSExtensions

class MapDroppedPinView: UIView {
    
    @IBOutlet var droppedPinImageView: UIImageView!
    @IBOutlet var droppedPinImageViewWidthConstraint: NSLayoutConstraint!
    
    init(imageWidth: CGFloat) {
        super.init(frame: .zero)
        
        addNibAsSubview()
        setupIconImageView(width: imageWidth)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) { nil }
    
    func addAsSubview(on view: UIView, above point: CGPoint) {
        
        view.addSubview(self)
       
        NSLayoutConstraint.activate([
            droppedPinImageView.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: point.x),
            droppedPinImageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: point.y)
        ])
        
        view.layoutIfNeeded()
    }
    
    func applyZoomScale(_ scale: CGFloat) {
        setLayerAnchorPoint(CGPoint(x: 0.5, y: 1))
        transform = .scale(1/scale)
    }
    
    func animateAppear(completion: @escaping () -> Void) {
        LocationIconAppearAnimator.animate(droppedPinImageView, origin: .bottom, completion: completion)
    }
    
    func animateDisappear(completion: @escaping () -> Void) {
        LocationIconDisappearAnimator.animate(droppedPinImageView, origin: .bottom, completion: completion)
    }
    
    private func setupIconImageView(width: CGFloat) {
        droppedPinImageView.image = Icons.droppedPin
        droppedPinImageViewWidthConstraint.constant = width        
    }
}

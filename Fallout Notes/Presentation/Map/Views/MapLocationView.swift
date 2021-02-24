import UIKit

class MapLocationView: UIView {
    
    weak var delegate: MapLocationViewDelegate?
    
    var viewModel: MapLocationViewModel {
        didSet { bindViewModel(oldValue: oldValue, animated: true) }
    }
        
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var iconImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var touchButton: UIButton!
    
    init(viewModel: MapLocationViewModel, imageWidth: CGFloat) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        addNibAsSubview()
    
        iconImageViewWidthConstraint.constant = imageWidth
        translatesAutoresizingMaskIntoConstraints = false
        
        setupButtonTouches()
                
        bindViewModel(oldValue: nil, animated: false)
    }
    
    required init?(coder: NSCoder) { nil }
    
    func addAsSubview(on view: UIView, centeringIconAt point: CGPoint) {
        
        view.addSubview(self)

        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: point.x),
            iconImageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: point.y)
        ])
    }
    
    private func setupButtonTouches() {
        
        touchButton.addTarget(self, action: #selector(scaleDownAnimated), for: .touchDown)
        touchButton.addTarget(self, action: #selector(scaleDownAnimated), for: .touchDragEnter)
        touchButton.addTarget(self, action: #selector(scaleUpAnimated), for: .touchDragExit)
        touchButton.addTarget(self, action: #selector(scaleUpAnimated), for: .touchUpOutside)
        touchButton.addTarget(self, action: #selector(scaleUpAnimated), for: .touchUpInside)
        touchButton.addTarget(self, action: #selector(viewTouchedUpInside), for: .touchUpInside)
    }
        
    private func bindViewModel(oldValue: MapLocationViewModel?, animated: Bool) {
        
        if viewModel.type != oldValue?.type {
            setIconImage(Icons.icon(for: viewModel.type), animated: animated)
        }
        
        if viewModel.name != oldValue?.name {
            setName(viewModel.name, animated: animated)
        }
    }
    
    private func setIconImage(_ image: UIImage, animated: Bool) {
        
        if animated {
            setIconImageAnimated(image)
        }
        else {
            setIconImage(image)
        }
    }
    
    private func setIconImageAnimated(_ image: UIImage) {
        
        let imageView = iconImageView!
        
        LocationIconDisappearAnimator.animate(imageView, origin: .center) {
            
            self.setIconImage(image)
            LocationIconAppearAnimator.animate(imageView, origin: .center)
        }
    }
    
    private func setIconImage(_ image: UIImage) {
        iconImageView.image = image
    }
    
    private func setName(_ name: String, animated: Bool) {
        
        if animated {
            
            UIView.transition(with: nameLabel, duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.nameLabel.text = name })
        }
        else {
            nameLabel.text = name
        }
    }
                
    @objc
    private func scaleDownAnimated() {
        UIView.animate(withDuration: 0.2) { self.alpha = 0.5 }
    }
    
    @objc
    private func scaleUpAnimated() {
        UIView.animate(withDuration: 0.2) { self.alpha = 1 }
    }
        
    @objc
    private func viewTouchedUpInside() {
        delegate?.mapLocationViewSelected(self, viewModel: viewModel)
    }
}

protocol MapLocationViewDelegate: AnyObject {
    
    func mapLocationViewSelected(_ view: MapLocationView, viewModel: MapLocationViewModel)
}

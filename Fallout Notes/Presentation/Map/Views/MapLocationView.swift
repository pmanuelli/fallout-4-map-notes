import UIKit

class MapLocationView: UIView {
    
    weak var delegate: MapLocationViewDelegate?
    
    var viewModel: MapLocationViewModel {
        didSet { bindViewModel(oldValue: oldValue, animated: true) }
    }
    
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var iconImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var nameLabel: UILabel!
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didReceiveTap))

    init(viewModel: MapLocationViewModel, imageWidth: CGFloat) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        addNibAsSubview()
        translatesAutoresizingMaskIntoConstraints = false
        addGestureRecognizer(tapGestureRecognizer)
        
        iconImageViewWidthConstraint.constant = imageWidth
        GreenBlurEffect.apply(on: nameLabel)
        
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
    private func didReceiveTap() {
        delegate?.mapLocationViewSelected(self, viewModel: viewModel)
    }
}

protocol MapLocationViewDelegate: AnyObject {
    
    func mapLocationViewSelected(_ view: MapLocationView, viewModel: MapLocationViewModel)
}

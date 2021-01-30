import UIKit

class MapLocationView: UIView {
    
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var iconImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var nameLabel: UILabel!
    
    init(image: UIImage, imageWidth: CGFloat, name: String) {
        super.init(frame: .zero)

        addNibAsSubview()
        setupIconImageView(image: image, width: imageWidth)
        setupNameLabel(name: name)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) { nil }
    
    func addAsSubview(on view: UIView, centeringIconAt point: CGPoint) {
        
        view.addSubview(self)

        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: point.x),
            iconImageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: point.y)
        ])
    }
    
    private func setupIconImageView(image: UIImage, width: CGFloat) {
        iconImageView.image = image
        iconImageViewWidthConstraint.constant = width
        
        GreenBlurEffect.apply(on: iconImageView)
    }
    
    private func setupNameLabel(name: String) {
        nameLabel.text = name
        
        GreenBlurEffect.apply(on: nameLabel)
    }
}

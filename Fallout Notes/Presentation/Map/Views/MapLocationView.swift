import UIKit

class MapLocationView: UIView {
    
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var iconImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var nameLabel: UILabel!
    
    init(viewModel: MapLocationViewModel, imageWidth: CGFloat) {
        super.init(frame: .zero)

        addNibAsSubview()
        setupIconImageView(image: Icons.icon(for: viewModel.type), width: imageWidth)
        setupNameLabel(name: viewModel.name)
        
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
    }
    
    private func setupNameLabel(name: String) {
        nameLabel.text = name
        
        GreenBlurEffect.apply(on: nameLabel)
    }
}

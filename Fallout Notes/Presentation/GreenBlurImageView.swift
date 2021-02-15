import UIKit

class GreenBlurImageView: UIImageView {

    override var image: UIImage? {
        set { super.image = newValue?.withRenderingMode(.alwaysTemplate) }
        get { super.image }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        refreshImage()
    }
    
    private func setup() {
        tintColor = Colors.greenDark
        clipsToBounds = false
        layerShadowColor = Colors.greenLight
        layerShadowRadius = 3
        layerShadowOpacity = 0.75
        layerShadowOffset = .zero
    }
    
    private func refreshImage() {
        let tempImage = image
        image = tempImage
    }
}

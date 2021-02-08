import UIKit

class HUDImageView: UIImageView {
    
    override var image: UIImage? {
        set { super.image = newValue?.withRenderingMode(.alwaysTemplate) }
        get { super.image }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        layerShadowOffset = CGSize(width: 1, height: 1)
        layerShadowRadius = 0
        layerShadowOpacity = 1
        layerShadowColor = .black
    }
    
    private func refreshImage() {
        let tempImage = image
        image = tempImage
    }
}

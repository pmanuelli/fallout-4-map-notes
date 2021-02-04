import UIKit

class GreenBlurLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textColor = Colors.greenDark
        clipsToBounds = false
        layerShadowColor = Colors.greenLight
        layerShadowRadius = 3
        layerShadowOpacity = 0.75
        layerShadowOffset = .zero
    }
}

import UIKit

class HUDLabel: UILabel {

    @IBInspectable
    var fontSize: CGFloat {
        get { font.pointSize }
        set { font = font.withSize(newValue) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        font = UIFont(name: "RobotoCondensed-Bold", size: fontSize)
        textColor = Colors.greenDark
        layerShadowColor = .black
        layerShadowOffset = CGSize(width: 1, height: 1)
        layerShadowRadius = 0
        layerShadowOpacity = 1
    }
}

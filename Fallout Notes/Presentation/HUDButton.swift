import UIKit

//@IBDesignable
class HUDButton: UIButton {
    
    @IBInspectable
    var fontSize: CGFloat {
        get { titleLabel?.font.pointSize ?? 0 }
        set { titleLabel?.font = titleLabel?.font.withSize(newValue) }
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
        
        setTitleColor(Colors.greenDark, for: .normal)
        setTitleShadowColor(.black, for: .normal)
        
        titleLabel?.font = UIFont(name: "RobotoCondensed-Bold", size: fontSize)
        titleLabel?.textColor = Colors.greenDark
        titleLabel?.layerShadowOffset = CGSize(width: 1, height: 1)
        titleLabel?.layerShadowRadius = 0
        titleLabel?.layerShadowOpacity = 1
    }
}

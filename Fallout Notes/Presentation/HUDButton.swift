import UIKit

//@IBDesignable
class HUDButton: UIButton {
    
    @IBInspectable
    var fontSize: CGFloat {
        get { titleLabel?.font.pointSize ?? 0 }
        set { titleLabel?.font = titleLabel?.font.withSize(newValue) }
    }
    
    override var isHighlighted: Bool {
        didSet { isHighlightedDidChange() }
    }
    
    private var titleShadowOpacityByState = [UIControl.State: CGFloat]()
    private var backgroundColorByState = [UIControl.State: UIColor?]()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setTitleShadowOpacity(_ opacity: CGFloat, for state: UIControl.State) {
        
        titleShadowOpacityByState[state] = opacity
        
        if self.state.contains(state) {
            titleLabel?.layerShadowOpacity = opacity
        }
    }
    
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        
        backgroundColorByState[state] = color
        
        if self.state.contains(state) {
            backgroundColor = color
        }
    }
    
    private func setup() {
        
        titleLabel?.font = UIFont(name: "RobotoCondensed-Bold", size: fontSize)
        titleLabel?.layerShadowOffset = CGSize(width: 1, height: 1)
        titleLabel?.layerShadowRadius = 0
        
        setupDefaultStyleForNormalState()
        
        setTitleColor(Colors.greenDark.withAlphaComponent(0.66), for: .highlighted)
        setTitleShadowColor(UIColor.black.withAlphaComponent(0.66), for: .highlighted)
    }
    
    func setupDefaultStyleForNormalState() {

        setTitleColor(Colors.greenDark, for: .normal)
        setTitleShadowColor(.black, for: .normal)
        setTitleShadowOpacity(1, for: .normal)
        setBackgroundColor(.clear, for: .normal)
    }
    
    func setupDefaultStyleForHighlightedState() {
        
        setTitleColor(.black, for: .highlighted)
        setTitleShadowColor(.clear, for: .highlighted)
        setTitleShadowOpacity(0, for: .highlighted)
        setBackgroundColor(Colors.greenDark, for: .highlighted)
    }
    
    private func isHighlightedDidChange() {
        
        if isHighlighted {
            showAsHighlightedState()
        }
        else {
            showAsNormalState()
        }
    }
    
    private func showAsHighlightedState() {
        
        if let titleShadowOpacity = titleShadowOpacityByState[.highlighted] ?? titleShadowOpacityByState[.normal] {
            titleLabel?.layerShadowOpacity = titleShadowOpacity
        }
        
        if let backgroundColor = backgroundColorByState[.highlighted] ?? backgroundColorByState[.normal] {
            self.backgroundColor = backgroundColor
        }
    }
    
    private func showAsNormalState() {
        
        if let titleShadowOpacity = titleShadowOpacityByState[.normal] {
            titleLabel?.layerShadowOpacity = titleShadowOpacity
        }
        
        if let backgroundColor = backgroundColorByState[.normal] {
            self.backgroundColor = backgroundColor
        }
    }
}

extension UIControl.State: Hashable { }

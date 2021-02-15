import UIKit

class TableViewCellSeparationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        heightAnchor.constraint(equalToConstant: 0.33).isActive = true
    }
}

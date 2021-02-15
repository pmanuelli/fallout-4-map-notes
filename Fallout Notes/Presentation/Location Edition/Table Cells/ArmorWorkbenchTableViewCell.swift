import UIKit

class ArmorWorkbenchTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {
   
    var viewModel: LocationEditionViewModel!
    
    private lazy var switchView = createSwitchView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryView = switchView
    }
    
    private func createSwitchView() -> UISwitch {
        
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        setupSwitchViewOffState(switchView)
    
        return switchView
    }
    
    private func setupSwitchViewOffState(_ switchView: UISwitch) {
        
        // TODO: Why can't use the exact color (28, 28, 28)? It doesn't show as expected
        let color = UIColor(white: 0.05, alpha: 1)
        
        switchView.backgroundColor = color
        switchView.tintColor = color
        switchView.clipsToBounds = true
        switchView.cornerRadius = switchView.bounds.height / 2.0
        
        selectionStyle = .none
    }
    
    @objc private func switchValueChanged() {
        
        if switchView.isOn {
            GreenBlurEffect.apply(to: switchView)
        }
        else {
            GreenBlurEffect.remove(from: switchView)
        }
    }
}

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
        
        let color = UIColor.darkGray
        switchView.backgroundColor = color
        switchView.tintColor = color
        switchView.clipsToBounds = true
        switchView.cornerRadius = switchView.bounds.height / 2.0
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

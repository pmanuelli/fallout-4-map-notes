import UIKit

class ArmorWorkbenchTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {
   
    var viewModel: LocationEditionViewModel! {
        didSet { bindViewModel() }
    }
    
    private var switchView: UISwitch { accessoryView as! UISwitch }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryView = createSwitchView()
    }
    
    private func createSwitchView() -> UISwitch {
        
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        setupOffState(on: switchView)
    
        return switchView
    }
    
    private func setupOffState(on switchView: UISwitch) {
        
        let color = UIColor.darkGray
        switchView.backgroundColor = color
        switchView.tintColor = color
        switchView.clipsToBounds = true
        switchView.cornerRadius = switchView.bounds.height / 2.0
    }
    
    private func bindViewModel() {
        switchView.isOn = viewModel.hasArmorWorkbench
        updateSwitchDesign()
    }
    
    @objc private func switchValueChanged() {
        
        updateSwitchDesign()
        viewModel.armorWorkbenchToggleChanged(enabled: switchView.isOn)
    }
    
    private func updateSwitchDesign() {
        
        if switchView.isOn { GreenBlurEffect.apply(to: switchView) }
        else { GreenBlurEffect.remove(from: switchView) }
    }
}

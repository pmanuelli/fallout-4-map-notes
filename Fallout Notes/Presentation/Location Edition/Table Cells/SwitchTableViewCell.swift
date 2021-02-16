import UIKit

class SwitchTableViewCell: UITableViewCell, AutoRegistrableTableViewCell {
   
    var viewModel: SwitchTableViewCellViewModel! {
        didSet { bindViewModel() }
    }
    
    private var switchView: UISwitch { accessoryView as! UISwitch }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryView = createSwitchView()
    }
    
    private func createSwitchView() -> UISwitch {
        
        let color = UIColor.darkGray
        
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        switchView.backgroundColor = color
        switchView.tintColor = color
        switchView.clipsToBounds = true
        switchView.cornerRadius = switchView.bounds.height / 2.0
    
        return switchView
    }
    
    private func bindViewModel() {
        
        textLabel?.text = viewModel.title
        switchView.isOn = viewModel.initialValue
        updateSwitchDesign()
    }
    
    @objc private func switchValueChanged() {

        viewModel.cellValueChanged(enabled: switchView.isOn)
        updateSwitchDesign()
    }
    
    private func updateSwitchDesign() {
        
        if switchView.isOn { GreenBlurEffect.apply(to: switchView) }
        else { GreenBlurEffect.remove(from: switchView) }
    }
}

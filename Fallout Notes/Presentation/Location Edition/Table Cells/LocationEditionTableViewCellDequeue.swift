import UIKit

struct LocationEditionTableViewCellDequeue {
    
    let identifier: String
    let locationEditionViewModel: LocationEditionViewModel?
    let switchTableCellViewModel: SwitchTableViewCellViewModel?

    init(identifier: String, locationEditionViewModel: LocationEditionViewModel) {
        self.identifier = identifier
        self.locationEditionViewModel = locationEditionViewModel
        self.switchTableCellViewModel = nil
    }
    
    init(identifier: String, switchTableCellViewModel: SwitchTableViewCellViewModel) {
        self.identifier = identifier
        self.switchTableCellViewModel = switchTableCellViewModel
        self.locationEditionViewModel = nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? LocationEditionTableViewCell, let viewModel = locationEditionViewModel {
            cell.viewModel = viewModel
        }
        else if let cell = cell as? SwitchTableViewCell, let viewModel = switchTableCellViewModel {
            cell.viewModel = viewModel
        }
        
        return cell
    }
}


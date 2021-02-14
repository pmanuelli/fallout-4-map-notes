import UIKit

struct LocationEditionTableViewCellDequeue {
    
    let identifier: String
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath,
                   viewModel: LocationEditionViewModel) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LocationEditionTableViewCell
        cell.viewModel = viewModel
        
        return cell
    }
}


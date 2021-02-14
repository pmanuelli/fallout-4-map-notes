import UIKit

class DeleteLocationTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {

    var viewModel: LocationEditionViewModel!
        
    @IBAction func deleteLocationButtonTouched() {
        viewModel.deleteLocationButtonTouched()
    }
}

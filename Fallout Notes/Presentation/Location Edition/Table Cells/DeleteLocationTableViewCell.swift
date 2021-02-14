import UIKit

class DeleteLocationTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {

    var viewModel: LocationEditionViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func cellTapped() {
        viewModel.deleteLocationButtonTouched()
    }
}

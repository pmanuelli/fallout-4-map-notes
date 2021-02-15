import UIKit

class LocationIconTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "LocationIconTableViewCell"
    static var nib: UINib { UINib(nibName: reuseIdentifier, bundle: Bundle(for: self)) }

    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var iconNameLabel: UILabel!
    
    private var viewModel: LocationIconTableViewCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setViewModel(_ viewModel: LocationIconTableViewCellViewModel) {
        
        self.viewModel = viewModel
        
        iconImageView.image = Icons.icon(for: viewModel.type)
        iconNameLabel.text = viewModel.name        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            viewModel?.cellSelected()
        }
        
        // Configure the view for the selected state
    }
}

import UIKit

class LocationIconTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "LocationIconTableViewCell"
    static var nib: UINib { UINib(nibName: reuseIdentifier, bundle: Bundle(for: self)) }

    @IBOutlet private var iconBackgroundImageView: UIImageView!
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
        
        GreenBlurEffect.apply(on: iconImageView)
        
        let backgroundIndex = (1...2).randomElement()!
        iconBackgroundImageView.image = UIImage(named: "icon_selection_background_\(backgroundIndex)")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            viewModel?.cellSelected()
        }
        
        // Configure the view for the selected state
    }
}

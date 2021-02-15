import UIKit
import RxSwift

class NotesTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {
    
    private var disposeBag = DisposeBag()
    
    var viewModel: LocationEditionViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAccessoryView()
        setupTapGestureRecognizer()
    }
    
    private func setupAccessoryView() {
        accessoryView = DisclosureIndicatorImageViewFactory.create()
    }
    
    private func setupTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func cellTapped() {
        viewModel.notesCellTouched()
    }
}


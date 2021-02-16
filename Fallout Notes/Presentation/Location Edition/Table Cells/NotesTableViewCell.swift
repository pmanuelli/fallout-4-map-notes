import UIKit
import RxSwift

class NotesTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {
    
    var viewModel: LocationEditionViewModel! {
        didSet { bindViewModel() }
    }
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDetailLabel()
        setupAccessoryView()
        setupTapGestureRecognizer()
    }
    
    private func setupDetailLabel() {
        GreenBlurEffect.apply(to: detailTextLabel!)
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
    
    private func bindViewModel() {

        notesChanged(viewModel.notes)
        
        disposeBag = DisposeBag()
        viewModel.output.notes
            .subscribe(onNext: { [weak self] in self?.notesChanged($0)})
            .disposed(by: disposeBag)
    }
    
    private func notesChanged(_ notes: String) {
                
        let maxLength = 25
        let trimmedNotes = notes.count > maxLength ? notes.prefix(maxLength - 3).appending("...") : notes
        
        // If the text set is empty then the following values does not appear, even if they are non empty
        detailTextLabel?.text = trimmedNotes.isEmpty ? " " : trimmedNotes
    }
}


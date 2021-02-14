import UIKit
import RxSwift

class NotesTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {

    @IBOutlet var notesTextView: UITextView!
    
    private var disposeBag = DisposeBag()
    
    var viewModel: LocationEditionViewModel! {
        didSet { bindViewModel() }
    }
        
    private func bindViewModel() {
        
        notesTextView.text = viewModel.notes
        
        disposeBag = DisposeBag()
        notesTextView.rx.text
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in self?.viewModel.updateLocationNotes($0) })
            .disposed(by: disposeBag)
    }
}


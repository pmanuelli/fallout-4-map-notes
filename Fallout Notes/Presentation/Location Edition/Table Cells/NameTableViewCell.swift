import UIKit
import RxSwift

class NameTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {
    
    private var disposeBag = DisposeBag()
    
    var viewModel: LocationEditionViewModel! {
        didSet { bindViewModel() }
    }
    
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
    
    private func bindViewModel() {
                
        nameChanged(viewModel.name)
        
        disposeBag = DisposeBag()
        viewModel.output.name
            .subscribe(onNext: { [weak self] in self?.nameChanged($0) })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func cellTapped() {
        viewModel.nameCellTouched()
    }
    
    private func nameChanged(_ name: String) {
        guard let label = detailTextLabel else { return }

        // If the text set is empty then the following values does not appear, even if they are non empty
        label.text = name.isEmpty ? " " : name
    }
}


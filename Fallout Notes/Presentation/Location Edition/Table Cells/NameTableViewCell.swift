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
        guard let label = detailTextLabel else { return }
        
        label.text = viewModel.name
        
        disposeBag = DisposeBag()
        
        viewModel.output.name
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    @objc
    private func cellTapped() {
        viewModel.nameCellTouched()
    }
}


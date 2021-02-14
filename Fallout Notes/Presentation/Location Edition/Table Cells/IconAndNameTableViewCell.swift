import UIKit
import RxSwift

class IconAndNameTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {
        
    @IBOutlet var iconImageViewContainer: UIView!
    @IBOutlet var iconImageView: GreenBlurImageView!
    @IBOutlet var nameTextField: UITextField!
    
    private var disposeBag = DisposeBag()
    
    var viewModel: LocationEditionViewModel! {
        didSet { bindViewModel() }
    }
    
    private var currentType: LocationType?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeIconButtonTouched))
        iconImageViewContainer.addGestureRecognizer(tapRecognizer)
    }
    
    private func bindViewModel() {
        
        disposeBag = DisposeBag()
        
        bindLocationType()
        bindLocationName()
    }
            
    private func bindLocationType() {
        
        currentType = viewModel.type
        iconImageView.image = viewModel.type.let { Icons.icon(for: $0) } else: { Icons.droppedPin }

        viewModel.output.locationType
            .subscribe(onNext: { [weak self] in self?.locationTypeChanged($0) })
            .disposed(by: disposeBag)
    }
    
    private func bindLocationName() {
        
        nameTextField.text = viewModel.name
        
        nameTextField.rx.text
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in self?.viewModel.updateLocationName($0) })
            .disposed(by: disposeBag)
    }
        
    @IBAction private func changeIconButtonTouched() {
        viewModel.changeLocationTypeButtonTouched()
    }
    
    private func locationTypeChanged(_ locationType: LocationType) {
                
        let origin: LocationIconDisappearAnimator.Origin = currentType == nil ? .bottom : .center
        currentType = locationType
        
        LocationIconDisappearAnimator.animate(iconImageView, origin: origin) {

            self.iconImageView.image = Icons.icon(for: locationType)
            GreenBlurEffect.apply(to: self.iconImageView)

            LocationIconAppearAnimator.animate(self.iconImageView, origin: .center)
        }
    }
}

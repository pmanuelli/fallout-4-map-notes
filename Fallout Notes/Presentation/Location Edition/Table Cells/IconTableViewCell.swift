import UIKit
import RxSwift

class IconTableViewCell: UITableViewCell, AutoRegistrableTableViewCell, LocationEditionTableViewCell {
        
    private let iconImageView = GreenBlurImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    private var disposeBag = DisposeBag()
    
    var viewModel: LocationEditionViewModel! {
        didSet { bindViewModel() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCellHeight()
        setupAccessoryView()
        setupTapGestureRecognizer()
    }
    
    private func setupCellHeight() {
        
        let heightConstraint = heightAnchor.constraint(equalToConstant: iconImageView.bounds.height + 16)
        heightConstraint.priority = UILayoutPriority.defaultHigh
        heightConstraint.isActive = true
    }
    
    private func setupTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapRecognizer)
    }
    
    private func setupAccessoryView() {
        accessoryView = createAccessoryView()
    }
    
    private func createAccessoryView() -> UIView {
        
        let horizontalSpacing = CGFloat(8)
        let disclosureIndicator = DisclosureIndicatorImageViewFactory.create()
        let disclosureIndicatorX = iconImageView.bounds.width + horizontalSpacing
        let disclosureIndicatorY = (iconImageView.bounds.height - disclosureIndicator.bounds.height) / 2
        disclosureIndicator.frame.origin = CGPoint(x: disclosureIndicatorX, y: disclosureIndicatorY)

        let viewWidth = iconImageView.bounds.width + horizontalSpacing + disclosureIndicator.bounds.width
        let viewHeight = iconImageView.bounds.height
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
    
        view.addSubview(iconImageView)
        view.addSubview(disclosureIndicator)
        
        return view
    }
    
    @objc private func cellTapped() {
        viewModel.iconCellTouched()
    }
    
    private func bindViewModel() {
        
        iconImageView.image = viewModel.type.let { Icons.icon(for: $0) } else: { Icons.droppedPin }

        disposeBag = DisposeBag()
        
        viewModel.output.type
            .subscribe(onNext: { [weak self] in self?.typeChanged($0) })
            .disposed(by: disposeBag)
    }
    
    private func typeChanged(_ locationType: LocationType) {
                
        let iconImageView = self.iconImageView
        
        LocationIconDisappearAnimator.animate(iconImageView, scaling: false) {
            
            iconImageView.image = Icons.icon(for: locationType)
            LocationIconAppearAnimator.animate(iconImageView, origin: .center)
        }
    }
}

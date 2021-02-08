import UIKit
import RxSwift
import RxCocoa

class LocationEditionViewController: UIViewController {
    
    lazy var mainView = LocationEditionView.loadNib()
    private let viewModel: LocationEditionViewModel
        
    private var currentLocationType: LocationType?
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: LocationEditionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocationType = viewModel.type
        
        setupNavigationItemButtons()
        setupIconTouch()
        
        bindLocationType()
        bindLocationName()
        bindLocationNotes()
    }
    
    private func bindLocationType() {
        
        if let type = viewModel.type {
            mainView.iconImageView.image = Icons.icon(for: type)
        }
        else {
            mainView.iconImageView.image = Icons.droppedPin
        }
        
        viewModel.output.locationType
            .subscribe(onNext: { [weak self] in self?.locationTypeChanged($0) })
            .disposed(by: disposeBag)
    }
    
    private func bindLocationName() {
        mainView.nameTextField.text = viewModel.name
        
        mainView.nameTextField.rx.text
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in self?.viewModel.updateLocationName($0) })
            .disposed(by: disposeBag)
    }
    
    private func bindLocationNotes() {
        mainView.notesTextView.text = viewModel.notes
        
        mainView.notesTextView.rx.text
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in self?.viewModel.updateLocationNotes($0) })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationItemButtons() {
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: viewModel,
                                           action: #selector(LocationEditionViewModel.cancelButtonTouched))
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: viewModel,
                                         action: #selector(LocationEditionViewModel.doneButtonTouched))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        
        viewModel.output.doneButtonEnabled
            .subscribe(doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func setupIconTouch() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: viewModel,
                                                          action: #selector(LocationEditionViewModel.locationTypeIconTouched))
        
        mainView.iconContainer.addGestureRecognizer(tapGestureRecognizer)
        
        mainView.changeIconButton.addTarget(viewModel,
                                            action: #selector(LocationEditionViewModel.locationTypeIconTouched),
                                            for: .touchUpInside)
    }
    
    private func locationTypeChanged(_ locationType: LocationType) {
                
        let origin: LocationIconDisappearAnimator.Origin = currentLocationType == nil ? .bottom : .center
        currentLocationType = locationType
        
        LocationIconDisappearAnimator.animate(mainView.iconImageView, origin: origin) {
            
            self.mainView.iconImageView.image = Icons.icon(for: locationType)
            GreenBlurEffect.apply(to: self.mainView.iconImageView)

            LocationIconAppearAnimator.animate(self.mainView.iconImageView, origin: .center)
        }
    }
}

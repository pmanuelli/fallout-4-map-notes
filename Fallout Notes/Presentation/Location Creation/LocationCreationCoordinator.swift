import UIKit
import RxSwift
import RxCocoa

class LocationCreationCoordinator {
        
    private let inheritedNavigationController: UINavigationController
    
    private let navigationController = UINavigationController()
    private var locationCreationViewModel: LocationCreationViewModel?
        
    private var completion: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.inheritedNavigationController = navigationController
        self.navigationController.modalPresentationStyle = .overFullScreen
    }
    
    func start(locationCoordinates: Coordinates, completion: (() -> Void)? = nil) {
        
        self.completion = completion
        
        let viewModel = LocationCreationViewModel(locationCoordinates: locationCoordinates,
                                                  createLocation: Infrastructure.shared.createLocation,
                                                  cancelLocationCreation: Infrastructure.shared.cancelLocationCreation)
        
        let viewController = LocationCreationViewController(viewModel: viewModel)
        
        observeViewModel(viewModel)
        locationCreationViewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
        inheritedNavigationController.present(navigationController, animated: true)
    }
        
    private func observeViewModel(_ viewModel: LocationCreationViewModel) {
        
        viewModel.output.doneButtonTouch
            .withUnretained(self)
            .subscribe(onNext: { coordinator, _ in coordinator.stop() })
            .disposed(by: disposeBag)
        
        viewModel.output.cancelButtonTouch
            .withUnretained(self)
            .subscribe(onNext: { coordinator, _ in coordinator.stop() })
            .disposed(by: disposeBag)
        
        viewModel.output.locationTypeIconTouch
            .withUnretained(self)
            .subscribe(onNext: { coordinator, _ in coordinator.startLocationIconSelection() })
            .disposed(by: disposeBag)
    }
    
    private func stop() {
        inheritedNavigationController.dismiss(animated: true)
        completion?()
    }
        
    private func startLocationIconSelection() {
        
        let viewModel = LocationIconSelectionViewModel()
        let viewController = LocationIconSelectionViewController(viewModel: viewModel)
        
        observeViewModel(viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func observeViewModel(_ viewModel: LocationIconSelectionViewModel) {
        
        viewModel.output.userDidSelectLocationType
            .subscribe(onSuccess: { [weak self] in self?.onUserDidSelectLocationType($0) })
            .disposed(by: disposeBag)
    }
    
    private func onUserDidSelectLocationType(_ type: LocationType) {

        navigationController.popViewController(animated: true)
        
        perform(after: 0.5) {
            self.locationCreationViewModel?.changeLocationType(type)
        }
    }
}

import UIKit
import RxSwift
import RxCocoa

class LocationCreationCoordinator {
    
    enum Result {
        case accept(type: LocationType, name: String)
        case cancel
    }
    
    private let inheritedNavigationController: UINavigationController
    private let navigationController = UINavigationController()
    
    private var locationCreationViewModel: LocationCreationViewModel?
        
    private var completion: ((Result) -> Void)?
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.inheritedNavigationController = navigationController
    }
    
    func start(_ completion: @escaping (Result) -> Void) {
        
        self.completion = completion
        
        let viewModel = LocationCreationViewModel()
        let viewController = LocationCreationViewController(viewModel: viewModel)
        
        observeViewModel(viewModel)
        locationCreationViewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
        inheritedNavigationController.present(navigationController, animated: true)
    }
        
    private func observeViewModel(_ viewModel: LocationCreationViewModel) {
        
        viewModel.output.doneButtonTouch
            .withUnretained(self)
            .subscribe(onNext: { coordinator, result in coordinator.stop(result: .accept(type: result.0, name: result.1)) })
            .disposed(by: disposeBag)
        
        viewModel.output.cancelButtonTouch
            .withUnretained(self)
            .subscribe(onNext: { coordinator, _ in coordinator.stop(result: .cancel) })
            .disposed(by: disposeBag)
        
        viewModel.output.locationTypeIconTouch
            .withUnretained(self)
            .subscribe(onNext: { coordinator, _ in coordinator.startLocationIconSelection() })
            .disposed(by: disposeBag)
    }
    
    private func stop(result: Result) {
        inheritedNavigationController.dismiss(animated: true)
        completion?(result)
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

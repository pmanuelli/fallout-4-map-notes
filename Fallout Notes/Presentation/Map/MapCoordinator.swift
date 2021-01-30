import UIKit
import RxSwift

class MapCoordinator {

    private let navigationController: UINavigationController
    
    private var mapViewModel: MapViewModel?
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let viewModel = MapViewModel()
        let viewController = MapViewController(viewModel: viewModel)
        mapViewModel = viewModel
        
        observeViewModel(viewModel)

        navigationController.pushViewController(viewController, animated: true)
        navigationController.hideNavigationBar()
    }
    
    private func observeViewModel(_ viewModel: MapViewModel) {
        viewModel.output.userDidDropPin
            .drive(onNext: { [weak self] _ in self?.startLocationIconSelection() })
            .disposed(by: disposeBag)
    }
    
    private func startLocationIconSelection() {
        
        let viewModel = LocationIconSelectionViewModel()
        let viewController = LocationIconSelectionViewController(viewModel: viewModel)
        
        observeViewModel(viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    private func observeViewModel(_ viewModel: LocationIconSelectionViewModel) {
        
        viewModel.output.userDidSelectLocationType
            .subscribe(onSuccess: { [weak self] in self?.onUserDidSelectLocationType($0) })
            .disposed(by: disposeBag)
    }
    
    private func onUserDidSelectLocationType(_ type: LocationType) {
        
        navigationController.popViewController(animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        perform(after: 0.5) {
            self.mapViewModel?.newLocationTypeSelected(type)
        }
    }
}

func perform(after delay: TimeInterval, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
}

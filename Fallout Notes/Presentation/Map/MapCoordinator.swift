import UIKit
import RxSwift

class MapCoordinator {

    private let navigationController: UINavigationController
    
    private var mapViewModel: MapViewModel?
    private var mapViewController: MapViewController?
    
    private var locationCreationCoordinator: LocationCreationCoordinator?
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let viewModel = MapViewModel()
        let viewController = MapViewController(viewModel: viewModel)
        mapViewModel = viewModel
        mapViewController = viewController
        
        observeViewModel(viewModel)

        navigationController.pushViewController(viewController, animated: true)
        navigationController.hideNavigationBar()
    }
    
    private func observeViewModel(_ viewModel: MapViewModel) {
        viewModel.output.newLocationPinDrop
            .subscribe(onNext: { [weak self] _ in self?.startLocationCreation() })
            .disposed(by: disposeBag)
    }
    
    private func startLocationCreation() {

        locationCreationCoordinator = LocationCreationCoordinator(navigationController: navigationController)
        locationCreationCoordinator?.start() { [weak self] in self?.onLocationSelectionCompleted($0) }
    }
    
    private func onLocationSelectionCompleted(_ result: LocationCreationCoordinator.Result) {
        
        perform(after: 0.5) {
            
            switch result {
            case .accept(type: let type, name: let name):
                self.mapViewModel?.newLocationAccepted(type: type, name: name)
            case .cancel:
                self.mapViewModel?.newLocationCancelled()
            }
        }
    }
}

func perform(after delay: TimeInterval, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
}

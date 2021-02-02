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
        
        let viewModel = MapViewModel(eventBus: Infrastructure.shared.eventBus)
        let viewController = MapViewController(viewModel: viewModel)
        mapViewModel = viewModel
        mapViewController = viewController
        
        observeViewModel(viewModel)

        navigationController.pushViewController(viewController, animated: true)
        navigationController.hideNavigationBar()
    }
    
    private func observeViewModel(_ viewModel: MapViewModel) {
        viewModel.output.newLocationPinDrop
            .subscribe(onNext: { [weak self] in self?.startLocationCreation(coordinates: $0) })
            .disposed(by: disposeBag)
    }
    
    private func startLocationCreation(coordinates: Coordinates) {

        locationCreationCoordinator = LocationCreationCoordinator(navigationController: navigationController, locationCoordinates: coordinates)
        locationCreationCoordinator?.start() { [weak self] in self?.onLocationSelectionCompleted() }
    }
    
    private func onLocationSelectionCompleted() {
    
    }
}

func perform(after delay: TimeInterval, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
}

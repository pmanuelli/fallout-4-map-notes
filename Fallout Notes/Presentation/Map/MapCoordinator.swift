import UIKit
import RxSwift

class MapCoordinator {

    private let navigationController: UINavigationController
    
    private var mapViewModel: MapViewModel?
    private var locationEditionCoordinator: LocationEditionCoordinator?
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let locations = Infrastructure.shared.locationRepository.readAll()
        
        let viewModel = MapViewModel(locations: locations, eventBus: Infrastructure.shared.eventBus)
        let viewController = MapViewController(viewModel: viewModel)
        mapViewModel = viewModel
        
        observeViewModel(viewModel)

        navigationController.pushViewController(viewController, animated: true)
        navigationController.hideNavigationBar()
    }
    
    private func observeViewModel(_ viewModel: MapViewModel) {
        viewModel.output.newLocationPinDrop
            .withUnretained(self)
            .subscribe(onNext: { coordinator, coordinates in coordinator.startLocationCreation(coordinates: coordinates) })
            .disposed(by: disposeBag)
        
        viewModel.output.locationSelection
            .withUnretained(self)
            .subscribe(onNext: { coordinator, location in coordinator.startLocationEdition(location: location) })
            .disposed(by: disposeBag)
    }
    
    private func startLocationCreation(coordinates: Coordinates) {
        locationEditionCoordinator = LocationEditionCoordinator(navigationController: navigationController)
        locationEditionCoordinator?.start(coordinates: coordinates) { [weak self] in
            self?.locationEditionCoordinator = nil
        }
    }
    
    private func startLocationEdition(location: Location) {
        locationEditionCoordinator = LocationEditionCoordinator(navigationController: navigationController)
        locationEditionCoordinator?.start(location: location) { [weak self] in
            self?.locationEditionCoordinator = nil
        }
    }
}

func perform(after delay: TimeInterval, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
}

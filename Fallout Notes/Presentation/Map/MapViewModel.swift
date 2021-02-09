import RxSwift
import RxCocoa

class MapViewModel {
    
    struct Output {
        let userInteractionEnabled: Driver<Bool>
        let newLocationPinDrop: Observable<Coordinates>
        let locationCreationCancel: Observable<Void>
        let locationSelection: Observable<Location>
        let locationViewModels: Observable<[MapLocationViewModel]>
    }
    
    lazy var output = Output(userInteractionEnabled: userInteractionEnabledSubject.asDriver(onErrorJustReturn: false),
                             newLocationPinDrop: newLocationPinDropSubject.asObservable(),
                             locationCreationCancel: locationCreationCancelSubject.asObservable(),
                             locationSelection: locationSelectionSubject.asObservable(),
                             locationViewModels: locationViewModelsSubject.asObservable())

    private let userInteractionEnabledSubject = BehaviorSubject<Bool>(value: true)
    private let newLocationPinDropSubject = PublishSubject<Coordinates>()
    private let locationCreationCancelSubject = PublishSubject<Void>()
    private let locationSelectionSubject = PublishSubject<Location>()
    private let locationViewModelsSubject = ReplaySubject<[MapLocationViewModel]>.create(bufferSize: 1)

    private var locationViewModels = [MapLocationViewModel]()
    
    private let disposeBag = DisposeBag()
    
    init(locations: [Location], eventBus: EventBusConsumer) {
        
        eventBus.observe()
            .subscribe(onNext: { [weak self] (event: LocationCreatedEvent) in self?.onLocationCreated(location: event.location) })
            .disposed(by: disposeBag)
        
        eventBus.observe()
            .subscribe(onNext: { [weak self] (event: LocationEditedEvent) in self?.onLocationEdited(location: event.location) })
            .disposed(by: disposeBag)
        
        eventBus.observe()
            .subscribe(onNext: { [weak self] (event: LocationCreationCancelledEvent) in self?.onLocationCreationCancelled() })
            .disposed(by: disposeBag)
                
        locationViewModels = locations.map { MapLocationViewModel(location: $0) }
        locationViewModelsSubject.onNext(locationViewModels)
    }
    
    func newLocationPinDropped(coordinates: Coordinates) {
        newLocationPinDropSubject.onNext(coordinates)
    }
    
    func locationViewModelSelected(_ viewModel: MapLocationViewModel) {
        locationSelectionSubject.onNext(viewModel.location)
    }
    
    private func onLocationCreated(location: Location) {
        locationViewModels.append(MapLocationViewModel(location: location))
        locationViewModelsSubject.onNext(locationViewModels)
    }
    
    private func onLocationEdited(location: Location) {
        guard let index = locationViewModels.firstIndex(where: { $0.location.id == location.id }) else { return }
        
        locationViewModels[index] = MapLocationViewModel(location: location)
        locationViewModelsSubject.onNext(locationViewModels)
    }
    
    private func onLocationCreationCancelled() {
        locationCreationCancelSubject.onNext(())
    }
}

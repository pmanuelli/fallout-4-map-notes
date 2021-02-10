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
        
        eventBus.locationCreated
            .subscribe(onNext: { [weak self] in self?.onLocationCreated(location: $0.location) })
            .disposed(by: disposeBag)
        
        eventBus.locationEdited
            .subscribe(onNext: { [weak self] in self?.onLocationEdited(location: $0.location) })
            .disposed(by: disposeBag)
        
        eventBus.locationDeleted
            .subscribe(onNext: { [weak self] in self?.onLocationDeleted(locationId: $0.locationId) })
            .disposed(by: disposeBag)
        
        eventBus.locationCreationCancel
            .subscribe(onNext: { [weak self] _ in self?.onLocationCreationCancelled() })
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
        guard let index = locationViewModels.firstIndex(where: { $0.id == location.id }) else { return }
        
        locationViewModels[index] = MapLocationViewModel(location: location)
        locationViewModelsSubject.onNext(locationViewModels)
    }
    
    private func onLocationDeleted(locationId: Location.Id) {
        locationViewModels = locationViewModels.filter { $0.id != locationId }
        locationViewModelsSubject.onNext(locationViewModels)
    }
    
    private func onLocationCreationCancelled() {
        locationCreationCancelSubject.onNext(())
    }
}

extension EventBusConsumer {
    
    var locationCreated: Observable<LocationCreatedEvent> { observe() }
    var locationEdited: Observable<LocationEditedEvent> { observe() }
    var locationDeleted: Observable<LocationDeletedEvent> { observe() }
    var locationCreationCancel: Observable<LocationCreationCancelledEvent> { observe() }
}

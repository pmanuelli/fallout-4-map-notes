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
    
    init(eventBus: EventBusConsumer) {
        
        eventBus.observe()
            .subscribe(onNext: { [weak self] (event: LocationCreatedEvent) in self?.onLocationCreated(location: event.location) })
            .disposed(by: disposeBag)
        
        eventBus.observe()
            .subscribe(onNext: { [weak self] (event: LocationEditedEvent) in self?.onLocationEdited(location: event.location) })
            .disposed(by: disposeBag)
        
        eventBus.observe()
            .subscribe(onNext: { [weak self] (event: LocationCreationCancelledEvent) in self?.onLocationCreationCancelled() })
            .disposed(by: disposeBag)
        
        // Sample locations
        let locations = [Location(id: UUID().uuidString, type: .junkyard, name: "Location 1", notes: "Some 1 notes", coordinates: Coordinates(x: 0.5, y: 0.5)),
                         Location(id: UUID().uuidString, type: .junkyard, name: "Location 2", notes: "Some 2 notes", coordinates: Coordinates(x: 0.2, y: 0.2)),
                         Location(id: UUID().uuidString, type: .junkyard, name: "Location 3", notes: "Some 3 notes", coordinates: Coordinates(x: 0.1, y: 0.1)),
                         Location(id: UUID().uuidString, type: .dome, name: "Location 4", notes: "Some other 4 notes", coordinates: Coordinates(x: 0.4, y: 0.4))]
        
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

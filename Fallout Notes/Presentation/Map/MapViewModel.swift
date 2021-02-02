import RxSwift
import RxCocoa

class MapViewModel {
    
    struct Output {
        let userInteractionEnabled: Driver<Bool>
        let newLocationPinDrop: Observable<Coordinates>
        let newLocationAccept: Observable<MapLocationViewModel>
        let newLocationCancel: Observable<Void>
    }
    
    lazy var output = Output(userInteractionEnabled: userInteractionEnabledSubject.asDriver(onErrorJustReturn: false),
                             newLocationPinDrop: newLocationPinDropSubject.asObservable(),
                             newLocationAccept: newLocationAcceptSubject.asObservable(),
                             newLocationCancel: newLocationCancelSubject.asObservable())

    private let userInteractionEnabledSubject = BehaviorSubject<Bool>(value: true)
    private let newLocationPinDropSubject = PublishSubject<Coordinates>()
    private let newLocationAcceptSubject = PublishSubject<MapLocationViewModel>()
    private let newLocationCancelSubject = PublishSubject<Void>()

    private let disposeBag = DisposeBag()
    
    init(eventBus: EventBusConsumer) {
        
        eventBus.observe()
            .subscribe(onNext: { [weak self] (event: LocationCreatedEvent) in self?.onLocationCreated(location: event.location) })
            .disposed(by: disposeBag)
        
        eventBus.observe()
            .subscribe(onNext: { [weak self] (event: LocationCreationCancelledEvent) in self?.onLocationCreationCancelled() })
            .disposed(by: disposeBag)
    }
    
    func newLocationPinDropped(coordinates: Coordinates) {
        newLocationPinDropSubject.onNext(coordinates)
    }
    
    private func onLocationCreated(location: Location) {
        let viewModel = MapLocationViewModel(type: location.type, name: location.name)
        newLocationAcceptSubject.onNext(viewModel)
    }
    
    private func onLocationCreationCancelled() {
        newLocationCancelSubject.onNext(())
    }
}

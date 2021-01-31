import RxSwift
import RxCocoa

class MapViewModel {
    
    struct Output {
        let userInteractionEnabled: Driver<Bool>
        let newLocationPinDrop: Observable<Void>
        let newLocationAccept: Observable<(LocationType, String)>
        let newLocationCancel: Observable<Void>
    }
    
    lazy var output = Output(userInteractionEnabled: userInteractionEnabledSubject.asDriver(onErrorJustReturn: false),
                             newLocationPinDrop: newLocationPinDropSubject.asObservable(),
                             newLocationAccept: newLocationAcceptSubject.asObservable(),
                             newLocationCancel: newLocationCancelSubject.asObservable())

    private let userInteractionEnabledSubject = BehaviorSubject<Bool>(value: true)
    private let newLocationPinDropSubject = PublishSubject<Void>()
    private let newLocationAcceptSubject = PublishSubject<(LocationType, String)>()
    private let newLocationCancelSubject = PublishSubject<Void>()

    func newLocationPinDropped() {
        newLocationPinDropSubject.onNext(Void())
    }
    
    func newLocationAccepted(type: LocationType, name: String) {
        newLocationAcceptSubject.onNext((type, name))
    }
    
    func newLocationCancelled() {
        newLocationCancelSubject.onNext(())
    }
}

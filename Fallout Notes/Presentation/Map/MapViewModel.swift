import RxSwift
import RxCocoa

class MapViewModel {
    
    struct Output {
        let userInteractionEnabled: Driver<Bool>
        let userDidDropPin: Driver<Void>
        let userSelectedNewLocationType: Driver<LocationType>
    }
    
    lazy var output = Output(userInteractionEnabled: userInteractionEnabledSubject.asDriver(onErrorJustReturn: false),
                             userDidDropPin: userDidDropPinSubject.asDriver(onErrorJustReturn: ()),
                             userSelectedNewLocationType: userSelectedNewLocationTypeSubject.asDriver(onErrorJustReturn: .building))

    private let userInteractionEnabledSubject = BehaviorSubject<Bool>(value: true)
    private let userDidDropPinSubject = PublishSubject<Void>()
    private let userSelectedNewLocationTypeSubject = PublishSubject<LocationType>()

    func userDidDropPin() {
        userDidDropPinSubject.onNext(Void())
    }
    
    func newLocationTypeSelected(_ type: LocationType) {
        userSelectedNewLocationTypeSubject.onNext(type)
    }
}

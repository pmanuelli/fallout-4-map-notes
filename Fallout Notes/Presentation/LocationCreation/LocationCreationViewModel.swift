import RxSwift
import RxCocoa

class LocationCreationViewModel {
        
    struct Output {
        let doneButtonEnabled: Observable<Bool>
        let doneButtonTouch: Observable<(LocationType, String)>
        let cancelButtonTouch: Observable<Void>
        let locationTypeIconTouch: Observable<Void>
        let locationType: Observable<LocationType>
    }
    
    lazy var output = Output(doneButtonEnabled: doneButtonEnabledSubject.asObservable(),
                             doneButtonTouch: doneButtonTouchSubject.asObservable(),
                             cancelButtonTouch: cancelButtonTouchSubject.asObservable(),
                             locationTypeIconTouch: locationTypeIconTouchSubject.asObservable(),
                             locationType: locationTypeSubject.asObservable())
    
    private var locationType: LocationType?
    private var locationName: String = ""
    
    private let doneButtonEnabledSubject = ReplaySubject<Bool>.createUnbounded()
    private let doneButtonTouchSubject = PublishSubject<(LocationType, String)>()
    private let cancelButtonTouchSubject = PublishSubject<Void>()
    private let locationTypeIconTouchSubject = PublishSubject<Void>()
    private let locationTypeSubject = PublishSubject<LocationType>()
    
    init() {

        updateDoneButtonEnabled()
    }
    
    @objc
    func locationTypeIconTouched() {
        locationTypeIconTouchSubject.onNext(())
    }
    
    @objc
    func cancelButtonTouched() {
        cancelButtonTouchSubject.onNext(())
    }
    
    @objc
    func doneButtonTouched() {
        guard let locationType = locationType, !locationName.isEmpty else { return }
        
        doneButtonTouchSubject.onNext((locationType, locationName))
    }
    
    func changeLocationType(_ type: LocationType) {
        locationType = type
        locationTypeSubject.onNext(type)
        updateDoneButtonEnabled()
    }
    
    func locationNameChanged(_ name: String) {
        locationName = name
        updateDoneButtonEnabled()
    }
    
    private func updateDoneButtonEnabled() {
        doneButtonEnabledSubject.onNext(locationType != nil && !locationName.isEmpty)
    }
}

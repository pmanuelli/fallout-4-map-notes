import RxSwift
import RxCocoa

class LocationCreationViewModel {
        
    struct Output {
        let doneButtonEnabled: Observable<Bool>
        let doneButtonTouch: Observable<Void>
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
    private var locationNotes: String = ""
    
    private let doneButtonEnabledSubject = ReplaySubject<Bool>.createUnbounded()
    private let doneButtonTouchSubject = PublishSubject<Void>()
    private let cancelButtonTouchSubject = PublishSubject<Void>()
    private let locationTypeIconTouchSubject = PublishSubject<Void>()
    private let locationTypeSubject = PublishSubject<LocationType>()
    
    private let locationCoordinates: Coordinates
    private let createLocation: CreateLocation
    private let cancelLocationCreation: CancelLocationCreation
    
    init(locationCoordinates: Coordinates,
         createLocation: CreateLocation,
         cancelLocationCreation: CancelLocationCreation) {
        
        self.locationCoordinates = locationCoordinates
        self.createLocation = createLocation
        self.cancelLocationCreation = cancelLocationCreation
        
        updateDoneButtonEnabled()
    }
    
    @objc
    func locationTypeIconTouched() {
        locationTypeIconTouchSubject.onNext(())
    }
    
    @objc
    func cancelButtonTouched() {
        cancelLocationCreation.execute()
        cancelButtonTouchSubject.onNext(())
    }
    
    @objc
    func doneButtonTouched() {
        guard let locationType = locationType else { return }
                
        let data = CreateLocationData(type: locationType,
                                      name: locationName,
                                      notes: locationNotes,
                                      coordinates: locationCoordinates)
        
        createLocation.execute(data: data)
        doneButtonTouchSubject.onNext(())
    }
    
    func changeLocationType(_ type: LocationType) {
        locationType = type
        locationTypeSubject.onNext(type)
        updateDoneButtonEnabled()
    }
    
    func updateLocationName(_ name: String) {
        locationName = name
        updateDoneButtonEnabled()
    }
    
    func updateLocationNotes(_ notes: String) {
        locationNotes = notes
        updateDoneButtonEnabled()
    }
    
    private func updateDoneButtonEnabled() {
        doneButtonEnabledSubject.onNext(locationType != nil && !locationName.isEmpty)
    }
}

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
    private var locationNotes: String = ""
    
    private let doneButtonEnabledSubject = ReplaySubject<Bool>.createUnbounded()
    private let doneButtonTouchSubject = PublishSubject<(LocationType, String)>()
    private let cancelButtonTouchSubject = PublishSubject<Void>()
    private let locationTypeIconTouchSubject = PublishSubject<Void>()
    private let locationTypeSubject = PublishSubject<LocationType>()
    
    private let locationCoordinates: Coordinates
    private let createLocation: CreateLocation
    
    init(locationCoordinates: Coordinates, createLocation: CreateLocation) {
        self.locationCoordinates = locationCoordinates
        self.createLocation = createLocation
        
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
        guard let locationType = locationType else { return }
        
        doneButtonTouchSubject.onNext((locationType, locationName))
        
        let data = CreateLocationData(type: locationType,
                                      name: locationName,
                                      notes: locationNotes,
                                      coordinates: locationCoordinates)
        
        createLocation.execute(data: data)
    }
    
    func changeLocationType(_ type: LocationType) {
        locationType = type
        locationTypeSubject.onNext(type)
        updateDoneButtonEnabled()
    }
    
    func changeLocationName(_ name: String) {
        locationName = name
        updateDoneButtonEnabled()
    }
    
    func changeLocationNotes(_ notes: String) {
        locationNotes = notes
        updateDoneButtonEnabled()
    }
    
    private func updateDoneButtonEnabled() {
        doneButtonEnabledSubject.onNext(locationType != nil && !locationName.isEmpty)
    }
}

import RxSwift
import RxCocoa

class LocationEditionViewModel {
        
    struct Output {
        let doneButtonEnabled: Observable<Bool>
        let doneButtonTouch: Observable<Void>
        let cancelButtonTouch: Observable<Void>
        let changeLocationTypeButtonTouch: Observable<Void>
        let locationType: Observable<LocationType>
    }
    
    lazy var output = Output(doneButtonEnabled: doneButtonEnabledSubject.asObservable(),
                             doneButtonTouch: doneButtonTouchSubject.asObservable(),
                             cancelButtonTouch: cancelButtonTouchSubject.asObservable(),
                             changeLocationTypeButtonTouch: changeLocationTypeButtonTouchSubject.asObservable(),
                             locationType: locationTypeSubject.asObservable())
    
    private(set) var coordinates: Coordinates
    private(set) var type: LocationType?
    private(set) var name: String?
    private(set) var notes: String
    
    private let doneButtonEnabledSubject = ReplaySubject<Bool>.createUnbounded()
    private let doneButtonTouchSubject = PublishSubject<Void>()
    private let cancelButtonTouchSubject = PublishSubject<Void>()
    private let changeLocationTypeButtonTouchSubject = PublishSubject<Void>()
    private let locationTypeSubject = PublishSubject<LocationType>()
    
    private let location: Location
    private let editLocation: EditLocation
    private let deleteLocation: DeleteLocation

    init(location: Location, editLocation: EditLocation, deleteLocation: DeleteLocation) {
        
        self.location = location
        self.editLocation = editLocation
        self.deleteLocation = deleteLocation
        
        self.coordinates = location.coordinates
        self.type = location.type
        self.name = location.name
        self.notes = location.notes

        updateDoneButtonEnabled()
    }
    
    @objc
    func changeLocationTypeButtonTouched() {
        changeLocationTypeButtonTouchSubject.onNext(())
    }
    
    @objc
    func cancelButtonTouched() {
        cancelButtonTouchSubject.onNext(())
    }
    
    @objc
    func doneButtonTouched() {
        guard let type = type, let name = name else { return }
        
        let data = EditLocationData(location: location,
                                    type: type,
                                    name: name,
                                    notes: notes,
                                    coordinates: coordinates)
        
        editLocation.execute(data: data)
        doneButtonTouchSubject.onNext(())
    }
    
    @objc
    func deleteLocationButtonTouched() {
        deleteLocation.execute(locationId: location.id)
        doneButtonTouchSubject.onNext(())
    }
    
    func changeLocationType(_ type: LocationType) {
        self.type = type
        locationTypeSubject.onNext(type)
        updateDoneButtonEnabled()
    }
    
    func updateLocationName(_ name: String) {
        self.name = name
        updateDoneButtonEnabled()
    }
    
    func updateLocationNotes(_ notes: String) {
        self.notes = notes
        updateDoneButtonEnabled()
    }
    
    private func updateDoneButtonEnabled() {
        guard let _ = type, let name = name else {
            doneButtonEnabledSubject.onNext(false)
            return
        }
        
        doneButtonEnabledSubject.onNext(!name.isEmpty)
    }
}

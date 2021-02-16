import RxSwift
import RxCocoa

protocol TextEditor {
    func editShortText(_ text: String, completion: @escaping (String) -> Void)
    func editLongText(_ text: String, completion: @escaping (String) -> Void)
}

class LocationEditionViewModel {
        
    struct Output {
        let doneButtonEnabled: Observable<Bool>
        let doneButtonTouch: Observable<Void>
        let cancelButtonTouch: Observable<Void>
        let changeLocationTypeButtonTouch: Observable<Void>
        let type: Observable<LocationType>
        let name: Observable<String>
        let notes: Observable<String>
    }
    
    lazy var output = Output(doneButtonEnabled: doneButtonEnabledSubject.asObservable(),
                             doneButtonTouch: doneButtonTouchSubject.asObservable(),
                             cancelButtonTouch: cancelButtonTouchSubject.asObservable(),
                             changeLocationTypeButtonTouch: changeLocationTypeButtonTouchSubject.asObservable(),
                             type: typeSubject.asObservable(),
                             name: nameSubject.asObservable(),
                             notes: notesSubject.asObservable())
    
    private(set) var coordinates: Coordinates
    private(set) var type: LocationType?
    private(set) var name: String?
    private(set) var notes: String
    private(set) var hasArmorWorkbench: Bool
    
    private let doneButtonEnabledSubject = ReplaySubject<Bool>.createUnbounded()
    private let doneButtonTouchSubject = PublishSubject<Void>()
    private let cancelButtonTouchSubject = PublishSubject<Void>()
    private let changeLocationTypeButtonTouchSubject = PublishSubject<Void>()
    private let typeSubject = PublishSubject<LocationType>()
    private let nameSubject = PublishSubject<String>()
    private let notesSubject = PublishSubject<String>()
        
    private let location: Location
    private let editLocation: EditLocation
    private let deleteLocation: DeleteLocation
    
    var textEditor: TextEditor?

    init(location: Location, editLocation: EditLocation, deleteLocation: DeleteLocation) {
        
        self.location = location
        self.editLocation = editLocation
        self.deleteLocation = deleteLocation
        
        self.coordinates = location.coordinates
        self.type = location.type
        self.name = location.name
        self.notes = location.notes
        self.hasArmorWorkbench = location.features.contains(.armorWorkbench)

        updateDoneButtonEnabled()
    }
        
    @objc
    func cancelButtonTouched() {
        cancelButtonTouchSubject.onNext(())
    }
    
    @objc
    func doneButtonTouched() {
        guard let type = type, let name = name else { return }
        
        var features = [Location.Feature]()
        if hasArmorWorkbench { features.append(.armorWorkbench) }
        
        let data = EditLocationData(location: location,
                                    coordinates: coordinates,
                                    type: type,
                                    name: name,
                                    notes: notes,
                                    features: features)
        
        editLocation.execute(data: data)
        doneButtonTouchSubject.onNext(())
    }
    
    func iconCellTouched() {
        changeLocationTypeButtonTouchSubject.onNext(())
    }
    
    func nameCellTouched() {
        
        textEditor?.editShortText(name ?? "", completion: { [weak self] in
            self?.name = $0
            self?.nameSubject.onNext($0)
            self?.updateDoneButtonEnabled()
        })
    }
    
    func notesCellTouched() {
        
        textEditor?.editLongText(notes, completion: { [weak self] in
            self?.notes = $0
            self?.notesSubject.onNext($0)
        })
    }
    
    func armorWorkbenchToggleChanged(enabled: Bool) {
        hasArmorWorkbench = enabled
    }
    
    func deleteLocationButtonTouched() {
        deleteLocation.execute(locationId: location.id)
        doneButtonTouchSubject.onNext(())
    }
    
    func changeLocationType(_ type: LocationType) {
        self.type = type
        typeSubject.onNext(type)
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

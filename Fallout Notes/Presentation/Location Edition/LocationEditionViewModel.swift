import RxSwift
import RxCocoa

protocol TextEditor: AnyObject {
    func editShortText(_ text: String, completion: @escaping (String) -> Void)
    func editLongText(_ text: String, completion: @escaping (String) -> Void)
}

protocol ActionConfirmator: AnyObject {
    func requestConfirmation(message: String, acceptMessage: String, cancelMessage: String, completion: @escaping (Bool) -> Void)
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
    
    private(set) var type: LocationType?
    private(set) var name: String
    private(set) var notes: String
    private(set) var hasArmorWorkbench: Bool
    private(set) var hasWeaponWorkbench: Bool
    
    private(set) var showDeleteButton: Bool

    private let doneButtonEnabledSubject = ReplaySubject<Bool>.createUnbounded()
    private let doneButtonTouchSubject = PublishSubject<Void>()
    private let cancelButtonTouchSubject = PublishSubject<Void>()
    private let changeLocationTypeButtonTouchSubject = PublishSubject<Void>()
    private let typeSubject = PublishSubject<LocationType>()
    private let nameSubject = PublishSubject<String>()
    private let notesSubject = PublishSubject<String>()
        
    weak var textEditor: TextEditor?
    weak var actionConfirmator: ActionConfirmator?
    
    private let behavior: LocationEditionViewModelBehavior
    
    init(behavior: LocationEditionViewModelBehavior) {
        
        self.behavior = behavior
        
        self.type = behavior.initialType
        self.name = behavior.initialName
        self.notes = behavior.initialNotes
        self.hasArmorWorkbench = behavior.initialFeatures.contains(.armorWorkbench)
        self.hasWeaponWorkbench = behavior.initialFeatures.contains(.weaponWorkbench)
        
        self.showDeleteButton = behavior.hasDeleteAction

        updateDoneButtonEnabled()
    }
        
    @objc
    func cancelButtonTouched() {
        behavior.cancelButtonTouched()
        cancelButtonTouchSubject.onNext(())
    }
    
    @objc
    func doneButtonTouched() {
        guard let type = type else { return }
        
        var features = [Location.Feature]()
        if hasArmorWorkbench { features.append(.armorWorkbench) }
        if hasWeaponWorkbench { features.append(.weaponWorkbench) }
        
        behavior.doneButtonTouched(type: type, name: name, notes: notes, features: features)
        doneButtonTouchSubject.onNext(())
    }
    
    func iconCellTouched() {
        changeLocationTypeButtonTouchSubject.onNext(())
    }
    
    func nameCellTouched() {
        
        textEditor?.editShortText(name, completion: { [weak self] in
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
    
    func weaponWorkbenchToggleChanged(enabled: Bool) {
        hasWeaponWorkbench = enabled
    }
    
    func deleteLocationButtonTouched() {
        
        actionConfirmator?.requestConfirmation(message: "Are you sure you want to delete this location?",
                                               acceptMessage: "Yes. Delete location",
                                               cancelMessage: "No. Go back") { confirmed in
            
            if confirmed {
                self.behavior.deleteButtonTouched()
                self.doneButtonTouchSubject.onNext(())
            }
        }
    }
    
    func changeLocationType(_ type: LocationType) {
        self.type = type
        typeSubject.onNext(type)
        updateDoneButtonEnabled()
    }
    
    private func updateDoneButtonEnabled() {
        doneButtonEnabledSubject.onNext(type != nil && !name.isEmpty)
    }
}

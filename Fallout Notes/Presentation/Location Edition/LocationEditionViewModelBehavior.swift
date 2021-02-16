protocol LocationEditionViewModelBehavior {

    var initialType: LocationType? { get }
    var initialName: String { get }
    var initialNotes: String { get }
    var initialFeatures: [Location.Feature] { get }
    
    var hasDeleteAction: Bool { get }
    
    func doneButtonTouched(type: LocationType, name: String, notes: String, features: [Location.Feature])
    func deleteButtonTouched()
    func cancelButtonTouched()
}

struct EditLocationBehavior: LocationEditionViewModelBehavior {
    
    var initialType: LocationType? { location.type }
    var initialName: String { location.name }
    var initialNotes: String { location.notes }
    var initialFeatures: [Location.Feature] { location.features }
    
    var hasDeleteAction = true
    
    private let location: Location
    private let editLocation: EditLocation
    private let deleteLocation: DeleteLocation
    
    init(location: Location, editLocation: EditLocation, deleteLocation: DeleteLocation) {
        self.location = location
        self.editLocation = editLocation
        self.deleteLocation = deleteLocation
    }
    
    func doneButtonTouched(type: LocationType, name: String, notes: String, features: [Location.Feature]) {
        
        let data = EditLocationData(location: location, coordinates: location.coordinates,
                                    type: type, name: name, notes: notes, features: features)
        
        editLocation.execute(data: data)
    }
    
    func deleteButtonTouched() {
        deleteLocation.execute(locationId: location.id)
    }
    
    func cancelButtonTouched() { }
}

struct CreateLocationBehavior: LocationEditionViewModelBehavior {
    
    var initialType: LocationType? = nil
    var initialName = ""
    var initialNotes = ""
    var initialFeatures = [Location.Feature]()
    
    var hasDeleteAction = false
    
    private let coordinates: Coordinates
    private let createLocation: CreateLocation
    private let cancelLocationCreation: CancelLocationCreation
    
    init(coordinates: Coordinates, createLocation: CreateLocation, cancelLocationCreation: CancelLocationCreation) {
        self.coordinates = coordinates
        self.createLocation = createLocation
        self.cancelLocationCreation = cancelLocationCreation
    }
    
    func doneButtonTouched(type: LocationType, name: String, notes: String, features: [Location.Feature]) {
        
        let data = CreateLocationData(coordinates: coordinates, type: type,
                                      name: name, notes: notes, features: features)
        
        createLocation.execute(data: data)
    }
    
    func deleteButtonTouched() { }
    
    func cancelButtonTouched() {
        cancelLocationCreation.execute()
    }
}

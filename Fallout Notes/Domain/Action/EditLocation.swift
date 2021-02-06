struct EditLocationData {
    let location: Location
    let type: LocationType
    let name: String
    let notes: String
    let coordinates: Coordinates
}

protocol EditLocation {
    func execute(data: EditLocationData)
}

class EditLocationDefault: EditLocation {
    
    private let repository: LocationRepository
    private let eventBus: EventBusProducer
    
    init(repository: LocationRepository, eventBus: EventBusProducer) {
        self.repository = repository
        self.eventBus = eventBus
    }
    
    func execute(data: EditLocationData) {
        
        let location = Location(id: data.location.id,
                                type: data.type,
                                name: data.name,
                                notes: data.notes,
                                coordinates: data.coordinates)
        
        repository.add(location)
        eventBus.send(event: LocationEditedEvent(location: location))
    }
}

struct LocationEditedEvent: Event {
    let location: Location
}
